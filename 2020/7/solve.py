#!/usr/bin/env python
#
# usage: solve.py <input>

import re
import sys

def dfs (data, node, fun, visited = None):
    result = 1
    if node not in data: return result
    for child in data[node]:
        if visited:
            if child in visited: continue
            visited.add(child)
        result += fun(dfs(data, child, fun, visited), node, child)
    return result

with open(sys.argv[1]) as f:
    inner = {}
    outer = {}
    for line in f:
        bags = re.split(" bags contain | bags?[,\.]\s?", line.strip())[:-1]
        if bags[1] != "no other":
            for contained in bags[1:]:
                num, bag = contained.split(' ', 1)
                num = int(num)
                inner.setdefault(bags[0], {}).update({bag: num})
                outer.setdefault(bag, {}).update({bags[0]: num})
    bag = "shiny gold"
    print(dfs(outer, bag, lambda x, _, __: x, set([bag])) - 1)
    print(dfs(inner, bag, lambda x, node, child: x * inner[node][child]) - 1)
