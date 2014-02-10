#!/bin/bash

# searchTitles.sh
# Searches for text in StackOverflow post titles, and finds IDs
# 2014-02-08
# Peter Burkimsher
# peterburk@gmail.com

# The working folder
thisFolder="/Users/peter/Sites/StackOverflow"

# Just run a simple grep. It's faster than anything native in PHP, and uses less RAM. 
grep "$1" "$thisFolder/titlePostId.txt"