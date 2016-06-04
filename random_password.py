#!/usr/bin/python3
'''
Usage: python3 random_password.py n

Prints a randomly-generated password using the current time as the seed.
Password in n chars long, where n > 3. Password contains
random uppercase letters, lowercase letters, digits, and one of the following
symbols !?#@
'''
import string
import random
import sys
import time

all_alphabets = [
    string.ascii_uppercase,
    string.ascii_lowercase,
    string.digits,
    '!?#@']

def id_generator(size, chars):
    return ''.join(random.choice(chars) for _ in range(size))

def doc_and_leave():
    print(__doc__, file=sys.stderr)
    sys.exit(1)

def main():
    if len(sys.argv) != 2: doc_and_leave()
    n = int(sys.argv[1])
    assert len(all_alphabets) == 4
    if n < 4: doc_and_leave()

    t = int(time.time())
    print('Seeding with', t)
    random.seed(t)

    # Get at least one of each
    s = ''.join(random.choice(x) for x in all_alphabets)
    s += id_generator(n - 4, ''.join(all_alphabets))
    s = list(s)
    random.shuffle(s)
    print(''.join(s))

if __name__ == '__main__':
    main()
