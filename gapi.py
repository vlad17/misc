from __future__ import print_function
import pickle
import sys
import numpy as np
import string
import os
import pandas as pd
from datetime import datetime, timedelta
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/calendar.readonly'

service = None

def init_gapi():
    store = file.Storage('/tmp/token.json')
    creds = store.get()
    if not creds or creds.invalid:
        print('did not find token /tmp/token.json, authenticating')
        credfile = os.path.expanduser('~/gcreds.json')
        flow = client.flow_from_clientsecrets(credfile, SCOPES)
        creds = tools.run_flow(flow, store)
    global service
    service = build('calendar', 'v3', http=creds.authorize(Http()))

icky_stuff = string.whitespace + string.punctuation
strippunc = str.maketrans(icky_stuff, " " * len(icky_stuff))

def topk(ls, keyfn, k):
    tops = []
    lsidx = list(range(len(ls)))
    k = min(k, len(ls))
    for i in range(k):
        mi = max(lsidx, key=lambda i: -np.inf if i < 0 else keyfn(ls[i]))
        tops.append(ls[mi])
        lsidx[mi] = -1
    return tops

# https://stackoverflow.com/questions/510357
import sys, tty, termios
def getch():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch

def classify(classcache, starttime, s):
    s = s.replace("sisu:", "").lower()
    s = s.translate(strippunc)
    s = " ".join(s.split())
    if s in classcache:
        print(starttime, s, "->", classcache[s])
        return classcache[s]
    keys = list(classcache)
    keyins = {k: k in s for k in keys}
    bestfit = topk(keys, lambda k: keyins[k] * len(classcache[k]), 3)
    while len(bestfit) < 3:
        bestfit.append('')
    print(starttime, s, "?")
    print("<spc>", classcache.get(bestfit[0]))
    print("1    ", classcache.get(bestfit[1]))
    print("2    ", classcache.get(bestfit[2]))
    print("<ent>", s)
    print("other", "<manual>")

    c = getch()
    m = {' ': 0, '1': 1, '2': 2}
    if c in m:
        classcache[s] = classcache[bestfit[m[c]]]
    elif c == chr(13):
        classcache[s] = s
    else:
        classcache[s] = c + input('enter new: ' + c)
    return classcache[s]


class FileBackedDict(dict):
    """Assumes single-process access"""

    BACKING_FILE = os.path.expanduser('~/.gapi.cache.pkl')

    @staticmethod
    def load():
        if not os.path.exists(FileBackedDict.BACKING_FILE):
            print('no backing file exists, making new one')
            return FileBackedDict({})
        with open(FileBackedDict.BACKING_FILE, 'rb') as f:
            return pickle.load(f)

    def save(self):
        with open(FileBackedDict.BACKING_FILE, 'wb') as f:
            pickle.dump(self, f)


def main(argv):
    init_gapi()
    fbd = FileBackedDict.load()

    key = datetime.now().strftime("%Y-%m-%d")
    if len(argv) > 1 and argv[1] == "--clean":
        if key in fbd:
            del fbd[key]
        del fbd["classifier"]
        fbd.save()
        return


    if key in fbd:
        print('already have analysis for', key)
        cc = list(fbd[key].columns)
        cc.remove("event")
        print(fbd[key][cc].head())

        df = fbd[key]
        print(df.head())
        dfby = df.groupby("classification").agg({'event': 'size', 'duration': 'sum'})
        dfby.sort_values('duration', inplace=True)
        dfby['percent'] = dfby['duration'] / dfby['duration'].sum() * 100
        print(dfby)
        print(dfby['duration'].sum() / 30 * 7, 'hrs/week')
        return

    print('loading last month of events')
    event, classification, starttime, duration = [], [], [], []

    now = datetime.utcnow()
    lastmo = now - timedelta(days=30)

    begin = lastmo.isoformat() + 'Z' # 'Z' indicates UTC time
    end = now.isoformat() + 'Z'
    page_tok = None
    events = []
    while True:
        events_result = service.events().list(calendarId='primary', timeMin=begin,
                                          timeMax=end, pageToken=page_tok,
                                          maxResults=2000, singleEvents=True,
                                        orderBy='startTime').execute()
        more_events = events_result.get('items', [])
        events += more_events
        next_page = events_result.get('nextPageToken')
        print('  fetched', len(events), 'events')
        if not next_page:
            break

    classcache = fbd.get("classifier", {})
    for e in events:
        if "sisu:" not in e["summary"]:
            continue
        start = e['start'].get('dateTime')
        end = e['end'].get('dateTime')
        s = e["summary"]
        import dateutil.parser as parser
        start = start and parser.parse(start)
        end = end and parser.parse(end)
        startstr = start.strftime("%Y-%m-%d %I:%M%p") if start else "<unk date>"
        c = classify(classcache, startstr, s)
        event.append(e)
        classification.append(c)
        starttime.append(start)
        if start and end:
            hrs = (end - start).total_seconds() / 3600
        else:
            hrs = np.nan
        duration.append(hrs)

    fbd["classifier"] = classcache
    df = pd.DataFrame({
        "event": event,
        "classification": classification,
        "starttime": starttime,
        "duration": duration})
    fbd[key] = df
    fbd.save()

if __name__ == '__main__':
  main(sys.argv)
