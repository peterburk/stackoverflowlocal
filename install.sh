#!/bin/bash

# Stack Overflow preparation commands. 
# This can be run as a shell script, but it would take over 3.5 hours. 
# I recommend running 1., 2., and 5. in parallel to save time. 
# The only required files for the server are:
# index.html, searchTitles.php, searchTitles.sh, titlePostId.txt, readPost.php, readPost.sh, readBlock.py, stackOverflowQas.txt.bz2
# Peter Burkimsher
# peterburk@gmail.com
# 2014-02-10

# 1. Download the StackOverflow data dump (1 hour 30 mins on fast internet in South Korea)
curl -L -O https://archive.org/download/stackexchange/stackoverflow.com-Posts.7z

# 2. Export the ID of every answered question (20 mins)
time bzgrep "AcceptedAnswerId=\"" stackoverflow.com-Posts.7z | sed -e 's/^.* Id=\"//' -e 's/\".*//' > questionIds.txt

# 3. Export the ID of every accepted answer (32 mins)
time bzgrep "AcceptedAnswerId=\"" stackoverflow.com-Posts.7z | sed -e 's/^.* AcceptedAnswerId=\"//' -e 's/\".*//' > answerIds.txt

# 4. Merge question IDs and answer IDs (a few seconds)
time cat answerIds.txt questionIds.txt | sort -n > qaIds.txt

# 5. Compile isQaId
cc -lm isQaId.c -o isQaId

# 6. Export just the answered questions and accepted answers (30 mins)
time bzgrep "row Id=" stackoverflow.com-Posts.7z | ./isQaId | bzip2 > stackOverflowQas.txt.bz2

# 7. Export the titles of answered questions (30 mins)
time bzgrep -b " AcceptedAnswerId=\"" stackoverflow.com-Posts.7z | sed -e 's/^.*Title=\"//' -e 's/\".*//' > titles.txt

# 8. Merge question IDs and titles (30 seconds)
time paste -d ">" questionIds.txt titles.txt > titlePostId.txt

# 9. Clean up
rm questionIds.txt
rm answerIds.txt
rm qaIds.txt
rm titles.txt
rm stackoverflow.com-Posts.7z
