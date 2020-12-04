#!/usr/bin/env python
#
# usage: solve.py [-v] <input>

import sys
from functools import reduce

verbose = sys.argv[1] == "-v"

def check (slope):
    with open(sys.argv[2 if verbose else 1]) as f:
        x = 0
        y = 0
        width = 0
        trees = 0
        for line in f:
            if verbose: print(line.strip() + " | ", end='')
            if not width: width = len(line.strip())
            if not y: y = slope[1] - 1
            else:
                if verbose: print()
                y = y - 1
                continue
            if line[x] == '#':
                trees = trees + 1
                if verbose: marker = 'X'
            elif verbose: marker = 'O'
            if verbose: print(line[:x] + marker + line[x + 1:].strip())
            x = (x + slope[0]) % width
    return trees

# part one
print(check((3, 1)))
# part two
print(reduce(lambda x, y: x * y,
             map(check, [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)])))
