# Run with some input to standard in with coin
# values separated by whitespace; e.g.,
#
# echo '5 10 25 5 5 10 10 5' | python coin_max.py
#
# Python 3 only.
# Returns the maximum value you can get by going first in
# the following game: taking turns, each player can choose a coin
# either at the beginning or end of the input sequence, which
# has value as specified by the input. The player removes the chosen
# coin, then his opponent goes.

import sys

def max_value_mem(coins, first, last, memoize):
    if memoize[first][last]:
        return memoize[first][last]
    if first == last:
        memoize[first][last] = 0
    elif last - first == 1:
        memoize[first][last] = coins[first]
    else:
        head = coins[first] + max_value_mem(coins, first + 1, last, memoize)
        tail = coins[last - 1] + max_value_mem(coins, first, last - 1, memoize)
        memoize[first][last] = max(head, tail)
    return memoize[first][last]

def max_value(coins):
    n = len(coins) + 1
    mem = [[None] * n] * n
    return max_value_mem(coins, 0, len(coins), mem)

if __name__ == '__main__':
    raw = '\n'.join(sys.stdin.readlines())
    split = [int(x) for x in raw.split()]
    maxval = max_value(split)
    print("max value if you go first is", maxval)
