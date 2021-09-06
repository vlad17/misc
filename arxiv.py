# collect metadata and pretty-print
# an arxiv entry with a given name
# also handles ACM inputs now
# TODO: write date and author extractors from google scholar
# given the title search. then adapters to other sites
# just need title extraction.

import warnings
warnings.filterwarnings("ignore")

import re
from dateutil import parser
from datetime import datetime
import requests
from bs4 import BeautifulSoup
import sys
import itertools

url = sys.argv[1]
name = sys.argv[2]

if url.startswith("https://arxiv.org"):

    r = requests.get(url)
    soup = BeautifulSoup(r.text, "lxml")

    title = soup.find("h1", class_="title mathjax").contents[1]

    date = soup.find("div", class_="dateline").text

    if 'last revised' in date:
        ix = date.index('last revised ') + len('last revised ')
    else:
        ix = date.index('Submitted on ') + len('Submitted on ')

    from dateutil import parser

    date = date[ix:]
    date = date.split(' ')[:3]
    import re
    date[-1] = re.search(r'\d+', date[-1]).group()
    toparse = ' '.join(date)
    date = datetime.strptime(toparse, '%d %b %Y')
    pubyr = date.year
    date = datetime.strftime(date, '%Y-%m-%d')

    authors = soup.find("div", class_="authors").contents[1:]

    authors = [BeautifulSoup(str(a), 'lxml').get_text() for a in authors]
    authors = [a for a in authors if ',' not in a and not a.strip().startswith('(')]
elif url.startswith("https://dl.acm.org/doi/"):
    # https://dl.acm.org/doi/10.1145/1553374.1553470

    r = requests.get(url)
    soup = BeautifulSoup(r.text, "lxml")

    title = soup.find("h1", class_="citation__title").text

    date = (soup.find("h3", text="Publication History")
            .find_parent("div", class_="section__separator")
            .find("ul", class_="rlist")
            .find("li", text=re.compile("Published: ")))
    date = parser.parse(date.text[len("Published: "):])
    pubyr = date.year
    date = datetime.strftime(date, '%Y-%m-%d')

    authors = soup.find("ul", {'ariaa-label': "authors"},
    class_="loa").findAll("li")[1:]
    authors = [x.find("a", class_="author-name") for x in authors]
    authors = [x['title'] for x in authors if x]
else:
    raise ValueError(url)

# reads title, date, pubyr, authors below.

authors_lastname = [a.rpartition(' ')[-1] for a in authors]
if len(authors_lastname) == 1:
    author_blurb = authors_lastname[0]
if len(authors_lastname) == 2:
    author_blurb = authors_lastname[0] + ' and ' + authors_lastname[1]
if len(authors_lastname) > 2:
    author_blurb = authors_lastname[0] + ' et al'

import urllib.parse

lookup = 'https://scholar.google.com/scholar?q=' + urllib.parse.quote(title)
citesoup = BeautifulSoup(requests.get(lookup).text, 'lxml')

cites_link = [x for x in citesoup.find_all('a') if x['href'].startswith('/scholar?cites')]
if cites_link:
    citeurl = 'https://scholar.google.com' + cites_link[0]['href']
    s = cites_link[0].contents[0]
    assert 'Cited by ' in s, s
    ncites = int(s[len('Cited by '):])
else:
    ncites = 0
    citeurl = lookup

from itertools import chain, repeat

indent = "   "
lines = [
    ":PROPERTIES:",
    f":date: {date}",
    f":title: {title}"]
lines += list(map(" ".join, zip(chain([":author:"], repeat(":author+:")), authors)))
lines += [
    f":cite: [[{url}][{author_blurb} {pubyr}]]",
    f":cites: [[{citeurl}][{ncites}]]",
    ":END:"]

print(f"#+NAME: {name}\n** {name}")
print("\n".join(indent + x for x in lines))
