'''
Usage: python3 quote_id.py quotes.csv

Given a CSV file with a header where the first column is a list of quotations,
invoking this command will result in a terminal-based "game" where a quote
is presented, then after the user presses enter the metadata about the quote
(all other columns) is revealed.
'''

import sys
import pandas
import random
import os

def parse_args():
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        sys.exit(1)
    return sys.argv[1]

def main():
    quotes_csv = parse_args()
    quotes = pandas.read_csv(quotes_csv)
    quotes_col = quotes.columns[0]
    other_cols = quotes.columns[1:]
    while True:
        os.system('cls' if os.name == 'nt' else 'clear')
        i = random.randint(0, len(quotes) - 1)
        row = quotes.iloc[i]
        print(row[quotes_col])
        if not sys.stdin.readline(): break
        for col in other_cols:
            print('{}: {}'.format(col, row[col]))
            if col != other_cols[-1]: print()
        
        if not sys.stdin.readline(): break

if __name__ == '__main__':
    main()
