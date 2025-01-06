# HPC-User-Provision-validation

## Name
Check User data Alpine

## Description
To verify the user privilages in all the directories and to verify the users data,accounts are created in all the required directories to work on the HPC.

## Usage
 To execute the code run : ./test_user_alpine.sh [ -u <user_name> | -l <user_list_file> ] <output_file>
 
 -u <user_name> : This for the single user ------> ./test_user_alpine.sh -u NetID
 
 -l <user_list_file> : This is for the list of users stored in a txt file -------> ./test_user_alpine.sh -l test.txt
 
 <output_file>: This is optional either for "-u" or "-l" if the user data is to be stored in a text file
     	    	use the third arugment so that the data will be sent to the output file if not the data will be displayed in the
	        	console.

## Author
Prudhvi Donepudi

