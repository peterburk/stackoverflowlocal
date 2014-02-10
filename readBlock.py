#!/usr/local/bin/python

# readBlock.py
# Reads a section of a file
# kevinm, 2009-08-14
# http://stackoverflow.com/a/1276786
# Used by Peter Burkimsher, because it's faster than using dd to take a section of a file

import sys

# (Peter) - I changed the buffer size to make runtime faster
BUFFER_SIZE = 400000

# Read args
if len(sys.argv) < 4:
    print >> sys.stderr, "Usage: %s input_file start_pos length" % (sys.argv[0],)
    sys.exit(1)
input_filename = sys.argv[1]
start_pos = int(sys.argv[2])
length = int(sys.argv[3])

# Open file and seek to start pos
input = open(sys.argv[1])
input.seek(start_pos)

# Read and write data in chunks
while length > 0:
    # Read data
    buffer = input.read(min(BUFFER_SIZE, length))
    amount_read = len(buffer)

    # Check for EOF
    if not amount_read:
        #print >> sys.stderr, "Reached EOF, exiting..."
        sys.exit(1)

    # Write data
    sys.stdout.write(buffer)
    length -= amount_read
