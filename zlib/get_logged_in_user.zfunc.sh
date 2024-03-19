#!/usr/bin/env zsh
# shellcheck shell=bash

# Function: get_logged_in_user
# Summary: Checks and returns the username of the currently logged-in user on a Mac. If no user is logged in, it returns an empty string.
#
## Arguments:
##  - No arguments required
## Output:
##  - Prints the username of the currently logged-in user. Prints an empty string if no user is logged in.
## Exit Codes:
##  - 0: Success
##  - 1: Command execution failed

function get_logged_in_user() {
    # Try to capture the logged-in user
    console_user=$(echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ && ! /loginwindow/ { print $3 }' 2>&1)

    if [ $? -ne 0 ]; then
        # If the DEBUG mode is set, also output what the command actually found, if anything. Otherwise, generic error.
        if [ ""$DEBUG"" = "True" ]; then
            echo "Failed to determine the logged-in user."
            echo "Output was: ""${console_user}""" # Optionally echo the error output
        else
            echo "Failed to determine the logged-in user."
        fi
        return 1
    fi

    # Check if a user is logged in and echo the username or an empty string
    if [[ -n "${console_user}" ]]; then
        echo "${console_user}"
    else
        echo ""
    fi

    # We ran successfully, exit gently.
    return 0
}

# Call the function. We leave this commented  (remove this line if you're sourcing this script)
#get_logged_in_user
