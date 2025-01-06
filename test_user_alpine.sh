#!/bin/bash
##
## FILE: test_user_alpine.sh
##
## DESCRIPTION:
## Scripts to Check accounts
## Directory, Symbolic links. CSU-general allocation for Alpine
## 
## AUTHOR: Prudhvi Donepudi
##
## DATE: 03/08/2023
## 
## VERSION: 1.0 (Stable)
##
## Usage
## To executethe code run : ./test_user_alpine.sh [ -u <username> | -l <user_list_file> ] <output_file>
## -u <username> : This for the single user ------> ./test_user_alpine.sh -u NetID
## -l <user_list_file> : This is for the list of users stored in a txt file -------> ./test_user_alpine.sh -l test.txt
## <output_file>: This is optional either for "-u" or "-l" if the user data is to be stored in a text file
##    		  use the third arugment so that the data will be sent to the output file if not the data will be displayed in the
##		  console.




# Check if correct number of arguments provided
if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: $0 [ -u <username> | -l <user_list_file> ] [<output_file>]"
    exit 1
fi

# Check if the output file can be created or appended to
if [[ $# -eq 3 ]]; then
    if ! touch "$3" 2>/dev/null; then
        echo "Error: cannot create or append to output file."
        exit 1
    fi
    exec &> "$3"
fi

# Function to check a single user
check_user() {
    local user="$1"
    echo "Checking user $user"

    # Test home directory
    local home_dir="/home/.colostate.edu/$user"
    if [[ -d "$home_dir" ]]; then
        echo "Home Directory: OK"
    else
        echo "Error: Home directory not found."
    fi

    # Test project directory
    local project_dir="/projects/.colostate.edu/$user"
    if [[ -d "$project_dir" ]]; then
        echo "Project Directory: OK"
    else
        echo "Error: Project directory not found."
    fi

    # Test scratch directory
    local scratch_dir="/scratch/alpine/.colostate.edu/$user"
    if [[ -d "$scratch_dir" ]]; then
        echo "Scratch Directory: OK"
    else
        echo "Error: Scratch directory not found."
    fi

    # Test symbolic link
    local path="/projects/.colostate.edu/${user%@colostate.edu}"
    if [[ -L "$path" ]]; then
        echo "Symbolic Link: OK"
        link=$(ls -ld "$path")
#        echo "Link : $link"      ##### If you want to see the link path uncomment this line of code#####

    else
        echo "Error: Symbolic link not found."
    fi

    # Test job allocations
    echo "Allocations:"
    sacctmgr -p show associations user="$user@colostate.edu"
    echo
}

# If flag is "-u", check single user
if [[ "$1" == "-u" ]]; then
    check_user "$2"

# If flag is "-l", read list of users from file and check each user
elif [[ "$1" == "-l" ]]; then
    while read -r user; do
        check_user "$user"
    done < "$2"

else
    echo "Error: invalid flag. Valid flags are -u (single user) or -l (user list file)."
    exit 1
fi

echo "Done."


