#!/bin/bash
#
# This bash script allows checking and applying system security updates.
#
# Author: Armoghan-ul-Mohmin
#
# More info here: https://github.com/Armoghans-Organization/Security-Patch-Manager
#
# Usage: ./script.sh
# Example: ./script.sh
#

##########################################################################
# Globals
##########################################################################

# Colors for text formatting
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
PURPLE=$(tput setaf 5)
BLUE=$(tput setaf 4)
NC=$(tput sgr0) # No Color

# Script Author Name
Author="Armoghan-ul-Mohmin"
# Script Name
Name="Security-Patch-Manager"
# Script Version
Version="1.0.0"
# Script Description
Description="Manage Security Updates"
##########################################################################
# Functions
##########################################################################

# Function to display colored messages
print_message() {
    local COLOR=$1
    local MESSAGE=$2
    echo -e "${COLOR}${MESSAGE}${NC}"
}

# Function to display exit message
exit_message() {
    clear
    print_linux_util_banner
    print_message "${BLUE}" "Thanks for using $Name by $Author."
    exit 0
}

# Trap Ctrl+C to display exit message
trap exit_message INT

# Display version information
show_version() {
    print_message "${GREEN}" "Script Version: $Version."
    echo -e "${GREEN}"
}

# Function to wait for Enter key press to continue
press_enter() {
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
    clear
}

# Function to print the contents of an ASCII banner from a file
print_banner() {
    # Specify the path to the ASCII banner file
    banner_file="banner.txt"

    # Check if the banner file exists
    if [ -f "$banner_file" ]; then
        # Print the contents of the ASCII banner file
        cat "$banner_file"
    else
        # Print an error message if the banner file is not found
        echo "Banner file not found: $banner_file"
    fi
}

# Function to print the Linux-Util banner
print_linux_util_banner() {
    echo -e "${PURPLE}"
    clear
    cat banner.txt
    echo
    print_message "${NC}------------------------------------------------${NC}"
    print_message "${CYAN}Welcome to ${BLUE}$Name${NC}${CYAN} - $Description${NC}"
    print_message "${CYAN}Author:${NC}${BLUE}$Author${NC}"
    print_message "${NC}------------------------------------------------${NC}"
    echo
}

##########################################################################
# Main script logic goes here
##########################################################################
