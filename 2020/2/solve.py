#!/usr/bin/env python
#
# usage: solve.py <input>

import sys

def parse (policy):
    limits, char = policy.split()
    return tuple(map(int, limits.split('-'))), char

def check_one (policy, password):
    count = password.count(policy[1])
    return count >= policy[0][0] and count <= policy[0][1]

def check_two (policy, password):
    pos = tuple(map(lambda x: x - 1, policy[0]))
    char = policy[1]
    length = len(password)
    return (pos[0] < length and pos[1] < length) and \
           ((password[pos[0]] == char) != (password[pos[1]] == char))

with open(sys.argv[1]) as f:
    input = [ (parse(policy), password)
              for policy, password in [ map(lambda x: x.strip(),
                                            line.split(':'))
                                        for line in f ]]
    # part one
    print(len([ (policy, password)
                for policy, password in input
                if check_one(policy, password) ]))
    # part two
    print(len([ (policy, password)
                for policy, password in input
                if check_two(policy, password) ]))
