#!/usr/bin/env python
#
# usage: solve.py <input>

import sys
from re import match

fields = {
    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    'byr': lambda f: int(f) >= 1920 and int(f) <= 2002,

    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    'iyr': lambda f: int(f) >= 2010 and int(f) <= 2020,

    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    'eyr': lambda f: int(f) >= 2020 and int(f) <= 2030,

    # hgt (Height) - a number followed by either cm or in:
    'hgt': lambda f:
        # If cm, the number must be at least 150 and at most 193.
        (match("\d+cm$", f) and int(f[:-2]) >= 150 and int(f[:-2]) <= 193) or
        # If in, the number must be at least 59 and at most 76.
        (match("\d+in$", f) and int(f[:-2]) >= 59 and int(f[:-2]) <= 76),

    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    'hcl': lambda f: match("#[0-9a-f]{6}$", f),

    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    'ecl': lambda f: f in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],

    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    'pid': lambda f: match("\d{9}$", f),

    # cid (Country ID) - ignored, missing or not.
}

def valid (passport):
    for f in passport:
        if f != "cid" and not fields[f](passport[f]): return False
    return True

def validate (valid = lambda p: True):
    validated = []
    check = lambda p: not fields - p.keys() and valid(p)
    with open(sys.argv[1]) as f:
        passport = {}
        for line in f:
            line = line.strip()
            if not line:
                if check(passport): validated.append(passport)
                passport = {}
            else:
                passport.update([ x.split(':') for x in line.split() ])
        if check(passport): validated.append(passport)
    return validated

# part 1
print(len(validate()))

# part 2
print(len(validate(valid)))
# or
print(len(validate(lambda p: not [ f
                                   for f in p
                                   if f != "cid" and not fields[f](p[f]) ])))
