import sys
import numpy as np
import time

def swap(ls, i, j):
    ls[i], ls[j] = ls[j], ls[i]

def suffix_array(text):
    sa = list(range(len(text)))
    chars = np.zeros(128, dtype=int)

    for suff in sa:
        chars[ord(text[suff])] += 1
    starts = np.cumsum(chars)
    starts = np.roll(chars, 1)
    starts[0] = 0

    for char in range(128):
        while chars[char]:
            ix = starts[char]
            at_curr = ord(text[sa[ix]])
            if at_curr == char:
                starts[char] += 1
                chars[char] -= 1
                continue
            swap(sa, ix, starts[at_curr])
            starts[char] += 1
            chars[char] -= 1
            starts[at_curr] += 1
            chars[at_curr] -= 1
    return sa

def _main():
    if len(sys.argv) != 2:
        print('Usage: python suffix.py text-file.txt')
        sys.exit(1)

    with open(sys.argv[1], 'r') as f:
        haystack = f.read().strip()

    assert all(ord(c) < 128 for c in haystack)

    t = time.time()
    sa = suffix_array(haystack)
    t = time.time() - t
    print('constructed suffix array in', t, 'sec')

    for i in sa:
        print(haystack[i:])

    # for needle in sys.stdin:
    #     occs = find(sa, needle)
    #     for occ in occs:
    #         print('    {}'.format(occ))


if __name__ == '__main__':
    _main()
