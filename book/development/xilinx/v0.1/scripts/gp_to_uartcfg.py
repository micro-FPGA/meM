#!/usr/bin/env python3

import fileinput

not_header = 1

str = "";

for line in fileinput.input():
    if line.startswith("index"):
        not_header = 0
    if not_header:
        words = line.split()
        str = str + words[1]
    not_header = 1

print("R"+str+"S");
