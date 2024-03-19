#!/usr/bin/env zsh
# shellcheck shell=bash

# Function: run_as_user
# Summary: Executes the given command as a specified user, utilizing `launchctl asuser` and `sudo -u` for reliable execution. Includes a debug mode for detailed output.
# Arguments:
#  - $1: Username of the user to run the command as.
#  - $@: The command and its arguments to be executed as the specified user.
# Output:
#  - Depending on DEBUG mode: either the command's output or detailed debug information including the command, user, UID, and command's output.
# Exit Codes:
#  - 0: Command executed successfully.
#  - 1: Invalid user specified or command failed to execute.
function run_as_user()
{
    local userToRunAs="$1"
    shift
    local uid=$(id -u "$userToRunAs")

    # If a valid user was provided, run the command as them.
    if [ "$userToRunAs" != "" ] && [ "$uid" != "" ]; then
        # If we are in debug mode, output some extra info.
        if [[ "${DEBUG}" == "True" ]]; then
            echo "Running command as user: $userToRunAs (UID: $uid)"
            echo "Command to run: '$@'"
        fi

        # Actually run the command and collect the output.
        cmd_run_result=$(launchctl asuser "$uid" sudo -u "$userToRunAs" "$@" 2>&1)
        # Collect the exit code in case we want to report it.
        exit_code="$?"
        
        if [[ "${DEBUG}" == "True" ]]; then
        # We are running in debug mode, so give a good summary of what we got when we ran the command.
            echo "Exit code: "$?""
            echo "Command output: "
            echo " "
            echo "${cmd_run_result}"
        else
            # We don't necessarily need to report if something was run, so just sleep for a tenth of a second instead.
            sleep 0.01
        fi

        if [ $? -ne 0 ]; then
            echo "Command execution failed"
            return 1
        fi
    else
        # Report if we weren't given a valid user.
        echo "Invalid user: $userToRunAs"
        return 1
    fi
}