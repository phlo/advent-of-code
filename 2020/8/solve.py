#!/usr/bin/env python
#
# usage: solve.py <input>

import sys

def execute (program, pc = 0, accu = 0, executed = None, fix = 0, analyze = 0):
    if not executed: executed = set()
    while pc < len(program):
        executed.add(pc)
        op, arg = program[pc]
        if fix and op != "acc":
            if op == "jmp":
                program[pc][0] = "nop"
                npc = pc + 1
            elif op == "nop":
                program[pc][0] = "jmp"
                npc = pc + arg
            result = execute(program, npc, accu, executed.copy(), 0, 1)
            if result is not None: return result
            program[pc][0] = op
        pc += arg if op == "jmp" else 1
        if op == "acc": accu += arg
        if pc in executed: return None if analyze else accu
    return accu

def parse (line):
    op, arg = line.split()
    return [op, int(arg)]

with open(sys.argv[1]) as f:
    program = [ parse(line) for line in f.readlines() ]
    # part 1
    print(execute(program))
    # part 2
    print(execute(program, fix = 1))
