#!/usr/bin/env python
#
# usage: solve.py <input>

import sys
import itertools

with open(sys.argv[1]) as f:
    input = [ int(x) for x in f.read().strip().split() ]
    # part one
    print([ a * b
            for a, b in itertools.combinations(input, 2)
            if a + b == 2020 ])
    # part two
    print([ a * b * c
            for a, b, c in itertools.combinations(input, 3)
            if a + b + c == 2020 ])
