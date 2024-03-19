#!/bin/zsh

# Function: remove_filepath
# Summary: Removes a specified file or directory, with additional checks for running as root (admin) and handling if no input is provided.
# Arguments:
#  - $1: The path of the file or folder to remove.
# Outputs:
#  - Informational, error, and success messages to standard output.
# Exit Codes:
#  - 0: File or directory was removed successfully.
#  - 1: No input provided or the file could not be removed.
function remove_filepath() {
    # Initialization of variables.
    local file=""                   # Path to the file or folder to remove.
    local is_admin=""               # Indicates if the script is run as root.
    local skip_admin_check=""       # Flags whether the admin check should be skipped.

    # Determine if the script is executed as root.
    local user="$(whoami)"
    if [[ "${user}" == "root" ]]; then
        echo "INFO: We are operating as root. Use of admin rights is implied."
        is_admin="Yes"
        skip_admin_check="Yes"  # Skip re-testing admin status.
    else
        echo "INFO: Not operating as root."
        echo "LOG: Please enter the password for this user account: "
        skip_admin_check="No"  # Ensure admin status is checked later if necessary.
    fi

    # Input validation: Check if a file path has been provided.
    if [[ -z "$1" ]]; then
        echo "ERROR: This script requires a file or folder to remove."
        return 1
    else
        file="$1"
    fi

    # Attempt to remove the specified file or directory. If it doesn't work, make our exit code zero.
    if [[ -f "${file}" || -d "${file}" ]]; then  # Check for the presence of file or directory.
        echo "INFO: ${file} is present. Attempting to remove it..."
        if sudo rm -rf "${file}"; then
            echo "INFO: ${file} was removed successfully!"
        else
            echo "ERROR: ${file} could not be removed. Exiting."
            return 1
        fi
    else
        echo "ERROR: ${file} does not exist or is not accessible."
        return 1
    fi

    # If we haven't error out, it worked. Exit with a code of zero.
    return 0
}
