#!/bin/zsh

# Function: check_if_root
# Summary: Checks if the current script execution context is running as the root user.
#
## Arguments:
##  - None required.
#
## Global Variables Set:
##  - IS_ADMIN: Indicates whether the script is running with root privileges ("Yes" or "No").
##  - SKIP_ADMIN_CHECK: Flags whether subsequent root privilege checks can be skipped ("Yes" or "No").
#
## Outputs:
##  - Echoes messages to standard output indicating whether the script is running as root.
##  - Instructs non-root users to provide a password for actions requiring root privileges.

check_if_root() {
    local user="$(whoami)"  # Capture the username of the current user.
    
    # Check if the current user is 'root'.
    if [[ "${user}" == "root" ]]; then
        # The script is running as root; set variables accordingly.
        echo "INFO: We are operating as root. Use of admin rights is implied."
        IS_ADMIN="Yes"
        SKIP_ADMIN_CHECK="Yes"
    else
        # The script is not running as root; notify and set variables.
        echo "INFO: We are not operating as root."
        echo "LOG: Please enter the password for this user account: "
        IS_ADMIN="No"
        SKIP_ADMIN_CHECK="No"
    fi
}

# Example call to the function (you can remove or comment this out as necessary)
check_if_root
