#!/usr/bin/env python
#
# usage: solve.py <input>

import sys
from functools import reduce

def decode (code, max):
    return reduce(lambda x, c: (x[0], x[1] - (x[1] - x[0]) // 2 - 1)
                               if c in "FL" else
                               (x[0] + (x[1] - x[0]) // 2 + 1, x[1]),
                  code,
                  (0, max))[0]

def getID (boarding):
    return decode(boarding[:7], 127) * 8 + decode(boarding[7:], 7)

with open(sys.argv[1]) as f:
    ids = sorted([ getID(boarding.strip()) for boarding in f ])
    # part 1
    print(ids[-1])
    # part 2
    for i in ids[1:]:
        if ids[i - ids[0] - 1] != i - 1:
            print(i - 1)
            break
