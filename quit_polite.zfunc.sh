#!/bin/zsh
# shellcheck shell=bash

# Function: quit_polite
# Summary: Checks if a specified application is running and, if so, quits the application politely using AppleScript. Ensures an application name is provided as an argument.
# Arguments:
#  - $1: The name of the application to check and potentially quit.
# Outputs:
#  - Echoes messages to standard output regarding the application's running status and quitting action. If no application name is provided, it echoes an error message.
# Exit Codes:
# - 0: Execution proceeded without requiring an action or application was quit successfully.
# - 1: No application name was provided as an argument.
function quit_polite() {
    # Check if an application name was provided as an argument.
    if [[ -z "$1" ]]; then
        echo "ERROR: No application name provided."
        return 1
    fi

    # If we were provided an arugment, set the variable the AppleScript will use to it.
    local APP_NAME="$1"

    # Use AppleScript for a friendlier quit for GUI apps. 
    if [[ $(process_running "$APP_NAME") == "Yes" ]]; then
        echo "INFO: $APP_NAME is running. Quitting the app."
        osascript -e "tell application \"$APP_NAME\" to quit"
    else
        echo "INFO: $APP_NAME is not running."
    fi
}