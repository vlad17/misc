"""
Usage: count_sports.py responses.csv

Counts the participation for sports in a csv.
"""

import sys
import csv
from tabulate import tabulate
from itertools import chain

def first_matching(ls, substring):
    return next(i for i, x in enumerate(ls) if substring.lower() in x.lower())

def clean_liststring(s):
    snip = 0
    while s[0] == '"' and s[-1] == '"': snip += 1
    if snip: s = s[snip:-snip]
    return [x.strip() for x in s.split(';')]

def main(argv):
    if len(argv) != 2:
        print(__doc__)
        sys.exit(1)
    csvfile = argv[1]

    print()
    print('Reading responses from {}...'.format(csvfile))

    with open(csvfile, 'r') as infile:
        dialect = csv.Sniffer().sniff(infile.read(1024))
        infile.seek(0)
        reader = csv.reader(infile, dialect=dialect, delimiter=',',
                            quotechar='"')
        header = next(reader)
        matrix = list(reader)

    name_col = first_matching(header, 'username')
    sports_col = first_matching(header, 'sport')
    is_female_col = first_matching(header, 'female')
    captain_col = first_matching(header, 'captain')

    for i in range(len(matrix)):
        matrix[i][sports_col] = clean_liststring(matrix[i][sports_col])

    all_sports = set(chain.from_iterable(x[sports_col] for x in matrix))
    sports_participants = {x:set() for x in all_sports}
    sports_females = {x:0 for x in all_sports}
    
    all_captains = set(x[name_col] for x in matrix
                       if 'no' not in x[captain_col].lower())    
    
    for i in range(len(matrix)):
        for sport in matrix[i][sports_col]:
            sports_participants[sport].add(matrix[i][name_col])
            if matrix[i][is_female_col] in ['Yes', 'yes']:
                sports_females[sport] += 1

    print()
    print(tabulate([[s, len(sports_participants[s]), sports_females[s]] for
                    s in all_sports],
                   ['Sport', 'Participants', '# Girls (for CoRec)'],
                   tablefmt='grid'))

    print()
    for sport in all_sports:
        print('{}: {}'.format(sport, ','.join(x for x in
                                              sports_participants[sport])))
    
    print()
    print('captains: ' + ','.join(all_captains))
    print()

if __name__ == "__main__":
    main(sys.argv)
