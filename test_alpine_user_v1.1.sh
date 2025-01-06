#!/usr/bin/env bash
##
## FILE: test_alpine_user_v1.1.sh
##
## DESCRIPTION: [Description]
## Scripts to Check accounts
## Directory, Symbolic links. CSU-general allocation for Alpine
## 
## AUTHOR: Prudhvi Donepudi
##
## DATE: 03/06/2023
## 
## VERSION: 1.1
##
## Usage
## Please give the list of users to be checked: user1 user2 user3  ......

read -p "Please give the list of users to be checked: " list

output_file="output.txt"


# Create the output file if it does not exist
if [ ! -f "$output_file" ]; then
    touch "$output_file"
fi

# Write the console output to a text file
exec &> "$output_file"

#read -p "Please give the list of users to be checked: " list 
for name in $list; do

echo "$name"
echo
###test home directory###

DIR="/home/.colostate.edu/$name"
if [ -d "$DIR" ]; then
  echo "Home_DIR: ok"
else
  echo "Error: Home directory not found. Can not continue."
fi

###test project directory###

DIR="/projects/.colostate.edu/$name"
if [ -d "$DIR" ]; then
  echo "Project_DIR: ok"
else
  echo "Error: project directory not found. Can not continue."
fi

###test scratch directory###

DIR="/scratch/alpine/.colostate.edu/$name"
if [ -d "$DIR" ]; then
  echo "Scratch_DIR: ok"
else
  echo "Error: Scratch directory not found. Can not continue."
fi

###test symbolic links###

# test symbolic link
path="/projects/.colostate.edu/${name%@colostate.edu}"
if test -L "$path"; then
#    echo "$path the symbolic link"
    link=$(ls -ld "$path")
#    echo "Link : $link"      ##### If you want to see the link path uncomment this line of code#####
    echo "Link: ok" 
else
    echo "$path is not a symbolic link"
fi

####test allocation###
echo "Allocations:" 
sacctmgr -p show associations user="$name@colostate.edu"
echo
done
