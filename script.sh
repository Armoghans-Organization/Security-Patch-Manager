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
    print_message "${BLUE}" "Thanks for using $Name by $Author."
    exit 0
}

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

##########################################################################
# Main script logic goes here
##########################################################################
