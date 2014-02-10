#!/bin/bash

# readPost.sh
# Does a binary search on the compressed StackOverflow database to find a desired post
# 2014-02-07 to 2014-02-10
# Peter Burkimsher
# peterburk@gmail.com

# The working folder
thisFolder="/Users/peter/Sites/StackOverflow"

# These values are basically arbitrary, found manually. 
# If they're too small, bzip2recover can't find a block boundary
# If they're too large, runtime slows down with all the disk accesses
oneBlock=800000
halfBlock=400000
quarterBlock=200000

#wc -l stackOverflowIndex.txt
#numberPosts=18066980
#numberBytes=`wc -c stackOverflowQas.txt.bz2 | cut -d ' ' -f 2`
numberBytes=2086493557
#expr 4960840356 / 18066980

#postId=21212938
#postId=12994700
#postId=5845865
#postId=4

postId=$1

# Initialise binary search variables
startBlock=1
lastBlock=$numberBytes
middleWidth=`expr $numberBytes / 2`

# While we haven't found the desired post ID
#while [  $middleWidth -gt $quarterBlock ]; do
while [  $middleWidth -gt 2 ]; do

	# Calculate the new block to read
	blockWidth=`expr $lastBlock - $startBlock`
	middleWidth=`expr $blockWidth / 2`
	middleBlock=`expr $startBlock + $middleWidth`
	
	# dd is too slow, use Python to read arbitrary bytes from the file
	#dd if=stackoverflow.com-Posts.7z of=binarySearchBlock.7z bs=1 count=$oneBlock skip=$middleBlock &> /dev/null
	python $thisFolder/readBlock.py $thisFolder/stackOverflowQas.txt.bz2 $middleBlock $oneBlock > $thisFolder/binarySearchBlock.7z
	
	# Recover that block to a text file
	# Redirect stderr errors (e.g. reading past the EOF) to /dev/null because it's faster than avoiding them. 
	bzip2recover $thisFolder/binarySearchBlock.7z &> /dev/null
	bzcat $thisFolder/rec* > $thisFolder/binarySearchBlock.txt 2> /dev/null
	rm $thisFolder/rec* 2> /dev/null
	
	# Read the row
	middleRowId=`grep -m 1 "<<" $thisFolder/binarySearchBlock.txt | cut -d \< -f 3`

	#echo $middleRowId
	
	# Is the desired row in the first or second half?
	if [[ $postId -le $middleRowId ]];
	then
		#echo "first half"
		lastBlock=$middleBlock
	else
		#echo "second half"
		startBlock=$middleBlock
	fi	
done

# Widen the final cut area
middleBlock=`expr $middleBlock - $halfBlock`
if [[ $middleBlock < 1 ]];
then
    middleBlock=1;
fi

# Read the block around the last row
python $thisFolder/readBlock.py $thisFolder/stackOverflowQas.txt.bz2 $middleBlock $oneBlock > binarySearchBlock.7z
bzip2recover $thisFolder/binarySearchBlock.7z &> /dev/null
bzcat $thisFolder/rec* > $thisFolder/binarySearchBlock.txt 2> /dev/null
rm $thisFolder/rec* 2> /dev/null

# Read the last row!
#grep "<row Id=\""$postId"\"" $thisFolder/binarySearchBlock.txt > $thisFolder/stackOverflowRow.txt
#cat $thisFolder/stackOverflowRow.txt
grep "<<"$postId"<>" $thisFolder/binarySearchBlock.txt

# Clean up
rm $thisFolder/binarySearchBlock.7z
rm $thisFolder/binarySearchBlock.txt