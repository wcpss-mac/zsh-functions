#!/bin/zsh

# Function: remove_pkg_receipt
# Summary: Removes a specified package receipt on a Mac if it exists.
# Arguments:
#  - $1: The package ID (receipt) to check and potentially remove.
# Outputs:
#  - Error messages to standard output for missing arguments or removal failures.
# Exit Codes:
#  - 0: Package ID does not exist or was successfully removed.
#  - 1: No package ID provided or the pkgutil --remove command failed.
function remove_pkg_receipt() {
    # Capture the package ID to check as a local variable.
    local receipt_to_check="$1"

    # Check if a package ID was actually provided.
    if [[ -z "$receipt_to_check" ]]; then
        echo "ERROR: No package ID provided."
        return 1
    fi

    # Use pkgutil to check if the package ID exists.
    pkgutil --pkgs | grep -q "$receipt_to_check"
    local pkg_exists=$?

    # If package ID exists, attempt to remove it.
    if [ $pkg_exists -eq 0 ]; then
        pkgutil --remove "$receipt_to_check"
        local removal_status=$?

        if [ $removal_status -ne 0 ]; then
            # pkgutil --remove command failed.
            echo "ERROR: Failed to remove package ID: $receipt_to_check."
            return 1
        else
            echo "INFO: Package ID: $receipt_to_check removed successfully."
        fi
    else
        # Package ID does not exist.
        echo "INFO: Package ID: $receipt_to_check does not exist. No action taken."
    fi

    return 0
}
