"""
Usage: python3 math_generator.py first_number second_number operation negatives

Generates 20 examples of math problems.

first_number is the number of digits the first number should have.
second_number is the number of digits the first number should have
operation is the operation tested (one of +, -, x, /)
negatives is either 'yes' or 'no', whether negatives should be tested.

Example:

python3 math_generator.py 2 1 + yes > output.txt

The above will generate exmaples adding 1-digit numbers to 2-digit numbers
that may be negative. The result will be saved to output.txt.
"""
import sys
import operator
import itertools
import random

def make_problem(first, second, operation, neg):
    max1 = pow(10, first) - 1
    lo1 = -max1 if neg else 0
    hi1 = max1
    max2 = pow(10, second) - 1
    lo2 = -max2 if neg else 0
    hi2 = max2
    first = random.randint(lo1, hi1)
    if operation == '-' and not neg:
        hi2 = first
    second = random.randint(lo2, hi2)
    if operation == '/':
        divis = [x for x in range(lo2, hi2 + 1)
                 if x != 0 and first % x == 0]
        easy = (-1 in divis) + (1 in divis) + \
               (first in divis) + (-first in divis)
        if len(divis) > easy:
            if 1 in divis: divis.remove(1)
            if -1 in divis: divis.remove(-1)
            if first in divis: divis.remove(first)
            if -first in divis: divis.remove(-first)
        second = random.choice(divis)
    return (first, second)

def main(argv):
    first_len = 0
    second_len = 0
    operation = '+'
    negatives = 'yes'

    try:
        if len(argv) != 5: raise Exception
        first_len = int(argv[1])
        second_len = int(argv[2])
        operation = argv[3]
        negatives = argv[4]
    except:
        print(__doc__, file=sys.stderr)
        return 1

    if first_len < 1 or first_len > 10:
        print('The first_number must be a number between 1 and 10',
              file=sys.stderr)
        return 1

    if second_len < 1 or second_len > 10:
        print('The second_number must be a number between 1 and 10',
              file=sys.stderr)
        return 1

    if operation not in '+-x/':
        print('The operation must be one of +, -, x, or /',
              file=sys.stderr)
        return 1

    if negatives not in ['yes', 'no']:
        print('The negatives indicator should be yes or no',
              file=sys.stderr)
        return 1
    negatives = negatives == 'yes'

    MAX_NUMSIZE = max(first_len, second_len) + 2
    SPACES_BETWEEN = MAX_NUMSIZE + 1
    SPACES = SPACES_BETWEEN * ' '

    l1 = SPACES + ' {: ' + str(MAX_NUMSIZE) + 'd}'
    l2 = SPACES + operation + '{: ' + str(MAX_NUMSIZE) + 'd}'
    l3 = SPACES + (MAX_NUMSIZE + 1) * '-'

    five_examples = '\n'.join([5 * s for s in [l1, l2, l3]])
    five_examples += '\n\n\n\n\n'

    def five_problems():
        n = negatives
        sequenced = tuple(make_problem(first_len, second_len, operation, n)
                          for i in range(5))
        return tuple(itertools.chain.from_iterable(zip(*sequenced)))

    for i in range(4):
        print(five_examples.format(*five_problems()))
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))
