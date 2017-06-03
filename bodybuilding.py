# compresses a bodybuilding.com workout routine into a cogent, easily-copyable
# csv

import requests
from bs4 import BeautifulSoup
import itertools

base = 'https://www.bodybuilding.com/fun/kris-gethins-4-weeks-2-shred-day-'


for i in itertools.count(1):
    r = requests.get(base + str(i))
    soup = BeautifulSoup(r.text, "lxml")
    if soup is None:
        break
    a = soup.find("div", class_='Article-body')
    if a is None:
        break
    xs = a("div", class_="dpg-plan-exercises")
    with open('day{:02d}.txt'.format(i), 'w') as f:
        for j, x in enumerate(xs):
            print('Workout', j, file=f)
            for ex_set in x("div", class_="dpgpt-content"):
                name = ex_set.find("a").text
                rest = ex_set.text
                rest = rest[len(name):]
                print('    {} | {}'.format(name, rest), file=f)
    print('fetched workout day', i)


print('fetching failed for workout day {}, terminating.'.format(i))
