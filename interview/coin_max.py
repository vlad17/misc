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
    assert (last - first) % 2 == 0
    if memoize[first][last] is not None:
        return memoize[first][last]
    if first == last:
        memoize[first][last] = 0
        return 0

    opp_head = max_value_mem(coins, first + 2, last, memoize)
    opp_tail = max_value_mem(coins, first + 1, last - 1, memoize)
    head = coins[first] + min(opp_head, opp_tail)

    opp_head = max_value_mem(coins, first + 1, last - 1, memoize)
    opp_tail = max_value_mem(coins, first, last - 2, memoize)
    tail = coins[last - 1] + min(opp_head, opp_tail)

    memoize[first][last] = max(head, tail)

    return memoize[first][last]

def max_value(coins):
    n = len(coins) + 1
    mem = [[None] * n for _ in range(n)] # obscure alias bug here
    return max_value_mem(coins, 0, len(coins), mem)

if __name__ == '__main__':
    raw = '\n'.join(sys.stdin.readlines())
    split = [int(x) for x in raw.split()]
    maxval = max_value(split)
    print("max value if you go first is", maxval)
