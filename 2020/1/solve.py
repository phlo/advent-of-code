#!/usr/bin/env python
#
# usage: solve.py <input>

import sys
from itertools import combinations

with open(sys.argv[1]) as f:
    input = [ int(x) for x in f.read().strip().split() ]
    # part 1
    print([ a * b
            for a, b in combinations(input, 2)
            if a + b == 2020 ])
    # part 2
    print([ a * b * c
            for a, b, c in combinations(input, 3)
            if a + b + c == 2020 ])
