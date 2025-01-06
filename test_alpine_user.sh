#!/usr/bin/env bash
##
## FILE: test_alpine_user.sh
##
## DESCRIPTION: [Description]
## Scripts to Check accounts
## Directory, Symbolic links. CSU-general allocation for Alpine
## 
## AUTHOR: [Author]
##
## DATE: 20230228
## 
## VERSION: 0.1
##
## Usage
## ./test_alpine_allocation
## Please give the list of users to be checked: user1@colostate.edu user2@colostate.edu ......


read -p "Please give the list of users to be checked: " list

for name in $list; do

#test
echo "$name"

DIR="/home/$name"
if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo "Home directory exists ${DIR}"
  echo
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "Error: ${DIR} not found. Can not continue."
  exit 1
fi

###test project directory###

DIR="/projects/$name"
if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo "Project directory exists ${DIR}"
  echo
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "Error: ${DIR} not found. Can not continue."
  exit 1
fi

###test scratch directory###

DIR="/scratch/alpine/$name"
if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo "Scratch directory exists ${DIR}"
  echo
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "Error: ${DIR} not found. Can not continue."
  exit 1
fi

###test symbolic links###

# test symbolic link
path="/projects/.colostate.edu/${name%@colostate.edu}"
if test -L "$path"; then
    echo "$path the symbolic link"
    link=$(ls -ld "$path")
    echo "Link : $link" 
    echo
else
    echo "$path is not a symbolic link"
fi

####test allocation###
echo "Allocations:" 
sacctmgr -p show associations user=$name

done
