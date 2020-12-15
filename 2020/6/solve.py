#!/usr/bin/env python
#
# usage: solve.py <input>

import sys
from functools import reduce

def groups(lines):
    group = []
    for line in lines:
        line = line.strip()
        if line: group.append(set(line))
        else:
            yield group
            group = []
    yield group

def count(reduction):
    return sum(map(lambda x: len(reduce(reduction, x)), groups(lines)))

with open(sys.argv[1]) as f:
    lines = f.readlines()
    # part 1
    print(count(lambda x, y: x | y))
    # part 2
    print(count(lambda x, y: x & y))
