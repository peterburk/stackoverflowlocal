/*
isQaID: Check if a row from the StackOverflow data dump is in a list of answered questions or accepted answers
Peter Burkimsher
peterburk@gmail.com
2014-02-10

To compile:
cc -lm isQaId.c -o isQaId
*/

#include <stdio.h>	 /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <stdlib.h>	 /* Standard library */

#define XML_LINE 100000	  /* Number of characters in one row */
#define ARRAYLENGTH 10292419 /* Number of question or answer IDs */

/*
textBetween: Get the text between two delimiters
	Properties
		char* thisText: The text to search within
		char* startText: The starting delimiter
		char* endText: The ending delimiter
		char* returnText: A string to copy the result to
	Return
		char* startPointer: NULL is thisText doesn't contain startText
*/
char* textBetween(char* thisText, char* startText, char* endText, char* returnText)
{
    char* startPointer = NULL;
    int stringLength = 0;

    startPointer = strstr(thisText, startText);
        
	// fprintf( stdout, "startPointer: %s\n", startPointer); fflush(stdout);
        
    if (startPointer != NULL)
    {
        startPointer = startPointer + strlen(startText);
        
        stringLength = strlen(startPointer) - (int)strlen(strstr(startPointer,endText));
        
        // Copy characters between the start and end delimiters
        strncpy(returnText,startPointer, stringLength);
        
        returnText[stringLength++] = '\0';
    }
    
    return startPointer;
}

/*
textBetweenInclusive: Get the text between two delimiters, including the delimiters
	Properties
		char* thisText: The text to search within
		char* startText: The starting delimiter
		char* endText: The ending delimiter
		char* returnText: A string to copy the result to
	Return
		char* startPointer: NULL is thisText doesn't contain startText
*/
char* textBetweenInclusive(char* thisText, char* startText, char* endText, char* returnText)
{
    char* startPointer = NULL;
    int stringLength = 0;

    startPointer = strstr(thisText, startText);
    
    if (startPointer != NULL)
    {
        // startPointer = startPointer + strlen(startText);
        
        stringLength = strlen(startPointer) - (int)strlen(strstr(startPointer,endText));
        stringLength = stringLength + strlen(endText);
        
        // Copy characters between the start and end delimiters
        strncpy(returnText,startPointer, stringLength);
        
        returnText[stringLength++] = '\0';
    }
    
    return startPointer;
}

/*
main: Checks rows to see if the ID of the row is in the qaIds.txt file
Reads rows from stdin. cuts out the ID, and checks it against the pre-read qaIds list. 
*/
int main(int argc, char** argv) 
{
	char soBufferArray[XML_LINE]; /* Line buffer for reading StackOverflow file */	
    char* soBuffer;
    
    // Strings for the post Id, row, body, and answer ID
    char* postIdString;
    char postIdArray[XML_LINE];

    char* rowString;
    char rowArray[XML_LINE];

    char* bodyString;
    char bodyArray[XML_LINE];

    char* answerIdString;
    char answerIdArray[XML_LINE];
	
	// Integers for the post ID and answer ID
    int postId=0;
	int answerId=0;
	
	// The start pointer for the textbetween subroutine
    char* startPointer = NULL;
    
    // A static array, because a normal int array maxes out at about 1 million elements due to heap constraints. 
    static int qaIds[ARRAYLENGTH];
	
	// The offset of the current ID in the qaIDs list
    int currentId=0;
    // The number of IDs in the qaIDs list
    int numberIds;
    // The value of the current ID from the qaIDs list
    int thisId;
    
    // Initialise arrays
    soBuffer = soBufferArray;
    postIdString = postIdArray;
    rowString = rowArray;
    bodyString = bodyArray;
    answerIdString = answerIdArray;
    
    // Read the QA IDs file into the qaIDs integer array
	FILE *file = fopen("qaIds.txt", "r");
    
    // Read lines as integers
    while(fscanf(file, "%d", &thisId) > 0) 
    {
    	// Append the ID to the qaIDs array
        qaIds[currentId] = thisId;
        
        // Increment the pointer
        currentId++;
    }
    
    // Don't forget to close the file!
    fclose(file);
    
	// Set the number of IDs
    numberIds=currentId;
    // Reset the current ID variable
    currentId=0;
        
    // Read a line from stdin.
    while (fgets(soBuffer, XML_LINE, stdin) != NULL)
    {
    	// Read the row ID
		startPointer = textBetween(soBuffer, "row Id=\"", "\"", postIdString);
    	postId = atoi(postIdString);
    	
    	// Move forward in the IDs array until the post ID is found, or not
    	while (qaIds[currentId] < postId)
		{
			currentId++;
		}
    	
    	// Prevent reading past the end of the array
    	if (currentId >= numberIds)
    	{
    		currentId=0;
    	}
    	
    	// If the post ID is found, print the row
		if (qaIds[currentId] == postId)
		{
			// Read the row
			startPointer = textBetweenInclusive(soBuffer, "<row Id=\"", "/>", rowString);
						
			// Read the body text
			startPointer = textBetween(rowString, " Body=\"", "\"", bodyString);
			
			// Read the accepted answer ID
			startPointer = textBetween(rowString, " AcceptedAnswerId=\"", "\"", answerIdString);
			answerId = atoi(answerIdString);
			
			// Print the row
			// fprintf( stdout, "%s\n", rowString); fflush(stdout);
			
			// Print a compressed version of the row
			fprintf( stdout, "<<%d<>%d><%s>>\n", postId, answerId, bodyString); fflush(stdout);
			
			// Clear the post and answer IDs
			postId=0;
			answerId=0;
			
			// Clear the strings
			strcpy(rowString, "");
			strcpy(bodyString, "");
			strcpy(answerIdString, "");
			strcpy(postIdString, "");
		}
    	
    	
    } // end while reading from stdin
    
}