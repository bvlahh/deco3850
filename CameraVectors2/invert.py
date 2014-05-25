#!/usr/bin/python

import sys
import numpy

if ( len(sys.argv) != 2 ):
    sys.exit(1)

m = sys.argv[1].split(",")

if ( len(m) != 16):
    sys.exit(1)

matrix = [
    [m[0], m[4], m[8], m[12]],
    [m[1], m[5], m[9], m[13]],
    [m[2], m[6], m[10], m[14]],
    [m[3], m[7], m[11], m[15]]
]

inv_matrix = numpy.linalg.pinv(matrix)

out_str = ""

for i in range(0,4):
    for j in range(0, 4):
        out_str += str(inv_matrix[j][i])
        if ( (i != 3) or (j != 3) ):
            out_str += ","

print out_str
