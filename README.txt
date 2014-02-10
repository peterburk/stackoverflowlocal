StackOverflow Local
Peter Burkimsher
peterburk@gmail.com
2014-02-10

This collection of scripts allows the StackOverflow data dump to be rapidly accessed while offline. 


-- About --
The data dump is compressed to only 2.09 GB, plus 230.5 MB for titles. 
Search time is about 8 seconds. 
Post reading time is about 6 seconds. 


-- Installing --
I recommend not running ./install.sh as normal! It will be very slow. 
Instead, open three Terminal windows and run the commands inside install.sh in parallel. 


-- Requirements --
You'll need cc to compile isQaId for setup. 
At runtime, you'll need a web server, PHP, Python, and bzip2recover. 


-- Developers --
You can run the scripts without the web server.
1. ./searchTitles.sh "your search here"
(returns the IDs and titles, separated by a > character)
2. ./readPost.sh 1234567
(returns the post, in compressed form)

The compressed format of the database is delimited by < and > characters as follows:
<<Post ID<>Answer Id><Body>>

For reference, the original StackOverflow database is 4.6 GB. 

Using dd instead of readBlock.py is possible, but post reading time increases to 30 seconds. 
