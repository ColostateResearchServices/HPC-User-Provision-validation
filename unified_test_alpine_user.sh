#!/usr/bin/env bash

##
## FILE: unified_test_alpine_user.sh
##
## DESCRIPTION: Script to check HPC user accounts, directories, symbolic links,
## and CSU-general allocations for Alpine. Supports checking a single user, a list
## of users provided interactively, or a list from a file. Outputs to either
## a specified file or the console. Includes verbose mode for detailed output.
## 
## AUTHOR: Prudhvi Donepudi
##
## DATE: 03/08/2023
## 
## VERSION: 2.0 Beta (untested) Unified version with help and verbose flags
##
## USAGE: 
## -h, --help: Display this help message and exit.
## -v, --verbose: Enable verbose output.
## Interactive mode: ./unified_test_alpine_user.sh [-v]
## Single user: ./unified_test_alpine_user.sh [-v] -u username
## User list file: ./unified_test_alpine_user.sh [-v] -l user_list_file [output_file]
## Output file is optional and applies to both single user and user list modes.

VERBOSE=0 # Default to non-verbose output

# Function to display help message
show_help() {
    echo "Usage: $0 [OPTIONS]... [ -u <username> | -l <user_list_file> ] [output_file]"
    echo
    echo "Options:"
    echo "  -h, --help       Display this help message and exit."
    echo "  -v, --verbose    Enable verbose output."
    echo
    echo "Check HPC user accounts, directories, symbolic links, and allocations."
    echo "Interactive mode, single user, or list from file modes are supported."
    echo "Output can be directed to a specified file."
}

# Function to check directories and symbolic links for a user
check_user() {
    local user="$1"

    ((VERBOSE)) && echo "Checking user: $user"

    # Directories to check
    local dirs=("/home/.colostate.edu/$user" "/projects/.colostate.edu/$user" "/scratch/alpine/.colostate.edu/$user")

    local path="/projects/.colostate.edu/${user%@colostate.edu}" # Path for symbolic link check

    # Check each directory
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            ((VERBOSE)) && echo "OK: Directory exists - $dir"
        else
            echo "ERROR: Directory not found - $dir"
        fi
    done

    # Check symbolic link
    if [ -L "$path" ]; then
        ((VERBOSE)) && echo "OK: Symbolic link exists - $path"
    else
        echo "ERROR: Symbolic link not found - $path"
    fi

    # Test job allocations
    ((VERBOSE)) && echo "Allocations for $user:"
    sacctmgr -p show associations user="$user@colostate.edu"
    ((VERBOSE)) && echo
}

# Main execution logic
main() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -u|-l)
                MODE="$1"
                VALUE="$2"
                shift 2
                ;;
            *)
                [[ -n "$MODE" ]] && OUTPUT_FILE="$1" || (show_help; exit 1)
                break
                ;;
        esac
    done

    # Output redirection if specified
    if [[ -n "$OUTPUT_FILE" ]]; then
        exec &> "$OUTPUT_FILE"
    fi

    # Mode handling
    if [[ -z "$MODE" ]]; then
        echo "Error: Mode (-u or -l) must be specified."
        show_help
        exit 1
    fi

    if [[ "$MODE" == "-u" ]]; then
        check_user "$VALUE"
    elif [[ "$MODE" == "-l" ]]; then
        while IFS= read -r user || [[ -n "$user" ]]; do
            check_user "$user"
        done < "$VALUE"
    else
        show_help
        exit 1
    fi

    echo "Done."
}

main "$@"