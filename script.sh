#!/bin/bash

#
# This bash script allows checking and applying system security updates.
#
# Author: Armoghan-ul-Mohmin
#
# More info here: https://github.com/Armoghans-Organization/Security-Patch-Manager
#
# Usage: ./script.sh [OPTIONS]
# Example: ./script.sh --root
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
# Script URL
URL="https://github.com/Armoghans-Organization/Security-Patch-Manager"

# Set up log directory
LOG_DIR="logs"
mkdir -p "$LOG_DIR" # Create the log directory if it doesn't exist
##########################################################################
# Functions
##########################################################################

# Function to display colored messages
print_message() {
    local COLOR=$1
    local MESSAGE=$2
    echo -e "${COLOR}${MESSAGE}${NC}"
}

# Function to log messages
log_message() {
    local LOG_FILE="$LOG_DIR/$1.log"
    local MESSAGE=$2
    echo "$(date +"%Y-%m-%d %T") - $MESSAGE" >>"$LOG_FILE"
}

# Function to display exit message
exit_message() {
    print_linux_util_banner
    print_message "${BLUE}" "Thanks for using $Name by $Author."
    exit
}

# Trap Ctrl+C to display exit message
trap exit_message INT

# Display version information
show_version() {
    echo -e "${GREEN}"
    print_message "${GREEN}" "$Name Version: $Version"
    exit 1
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
    print_banner
    echo
    print_message "${NC}---------------------------------------------------------------${NC}"
    print_message "${CYAN}Welcome to ${BLUE}$Name${NC}${CYAN} - $Description${NC}"
    print_message "${CYAN}Author:${NC}${BLUE}$Author${NC}"
    print_message "${NC}---------------------------------------------------------------${NC}"
    echo
}

# Function to check if the script is run with root privileges
RUN_AS_ROOT() {
    if [ "$EUID" -ne 0 ]; then
        if [ "$1" = "--root" ] || [ "$1" = "-r" ]; then
            print_linux_util_banner
            sudo "$0" "$@"
            exit
        fi
        print_message "$RED" "This script must be run as root."
        exit 1
    fi
}

# Check if User has working internet connection or not
internet_connection() {
    ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_message "${GREEN}" "Internet connection is working."
        echo
    else
        print_message "${RED}" "No internet connection."
        exit
    fi
}

# Function to list available security updates
list_security_updates() {
    print_linux_util_banner
    print_message "$CYAN" "Listing available security updates..."
    print_message "$NC" "----------------------------------------"
    echo
    # Call log_message function to log command execution
    log_message "update" "Executing 'sudo apt update' command."
    # Execute the command in the background, redirecting output to log file
    sudo apt update 2>&1 | grep -v 'WARNING: apt does not have a stable CLI interface.' >>"$LOG_DIR/update.log" &
    sudo apt list --upgradable 2>/dev/null | awk -F/ 'BEGIN {OFS="\t"} { printf "%-40s%-25s%-25s\n", $1, $2, $3 }' | column -t -s $'\t' | awk '{ print $1, $2, $3 }' >>"$LOG_DIR/update.log" &
    # List security updates with colors
    sudo apt list --upgradable 2>/dev/null | awk -F/ 'BEGIN {OFS="\t"} { printf "%-40s%-25s%-25s\n", $1, $2, $3 }' | column -t -s $'\t' | awk '{ printf "\033[32m%-40s\033[0m\t\033[33m%-25s\033[0m\t\033[34m%-25s\033[0m\n", $1, $2, $3 }'
    exit
}

# Function to apply security updates with live progress bar
apply_security_updates() {
    print_linux_util_banner
    print_message "$GREEN" "Applying security updates..."

    # Run apt update in the background
    sudo apt update >/dev/null 2>&1 &
    update_pid=$!

    # Initialize variables
    progress_bar=""
    percentage=0
    width=100 # Adjust the width of the progress bar

    # Display a live progress bar while waiting for apt update to finish
    while kill -0 $update_pid 2>/dev/null; do
        ((percentage++))
        if [ "$percentage" -gt "$width" ]; then
            break
        fi
        progress_bar+="="
        printf "\r[%-${width}s] %d%%" "$progress_bar" "$percentage"
        sleep 1
    done

    # Complete the progress bar to 100%
    while [ "$percentage" -lt "$width" ]; do
        ((percentage++))
        progress_bar+="="
        printf "\r[%-${width}s] %d%%" "$progress_bar" "$percentage"
        sleep 0.1
    done
    # Run apt upgrade with progress display
    upgrade_output=$(sudo apt upgrade -y 2>&1)

    # Filter out the warning and add colors
    filtered_output=$(echo "$upgrade_output" | grep -v 'WARNING: apt does not have a stable CLI interface.')
    print_message "$GREEN" "$filtered_output"

    print_message "$GREEN" "Security updates applied successfully."
    exit
}

# Function to perform apt autoclean
perform_autoclean() {
    print_message "$GREEN" "Running 'apt autoclean'..."
    # Run apt autoclean and filter out the warning
    autoclean_output=$(sudo apt autoclean 2>&1 | grep -v 'WARNING: apt does not have a stable CLI interface.')
    # Display the results in tabular form with colors
    echo "$autoclean_output" | awk '{ print "\033[32m" $0 "\033[0m" }' | column -t
    print_message "$GREEN" "'apt autoclean' completed successfully."
    exit
}

# Function to perform apt autoremove with improved formatting
perform_autoremove() {
    print_linux_util_banner
    print_message "$GREEN" "Running 'apt autoremove'..."

    # Run apt autoremove and filter out the warning
    autoremove_output=$(sudo apt autoremove -y 2>&1 | grep -v 'WARNING: apt does not have a stable CLI interface.')

    # Extract and display the relevant information with improved formatting
    echo -e "$autoremove_output" | awk '
        BEGIN { RS=""; FS="\n" }
        {
            packages_removed = 0
            for (i = 1; i <= NF; i++) {
                if ($i ~ /The following packages will be REMOVED:/) {
                    print "\033[32m" "The following packages will be REMOVED:" "\033[0m"
                    packages_removed = 1
                } else if (packages_removed && $i ~ /^[[:space:]]/) {
                    if ($i ~ /^Reading package lists/ || $i ~ /^Building dependency tree/ || $i ~ /^Reading state information/ || $i ~ /^0 upgraded, 0 newly installed, 0 to remove and 34 not upgraded/) {
                        # Ignore these lines
                    } else {
                        print "\033[31m" $i "\033[0m"
                    }
                }
            }
            if (packages_removed) {
                print "\n\033[32m" "0 upgraded, 0 newly installed, 0 to remove and 34 not upgraded." "\033[0m\n"
            }
        }
    '

    print_message "$GREEN" "'apt autoremove' completed successfully."
    exit
}

##########################################################################
# Help Menu and Flags
##########################################################################
show_help() {
    echo -e "${PURPLE}"
    cat banner.txt
    echo
    print_message "${NC}" "$Name $Version ($URL)"
    print_message "${NC}" "Author: $Author"
    print_message "${NC}" "Description: $Description"
    echo
    print_message "${GREEN}" "Usage:${NC} $0 [${YELLOW}OPTIONS${NC}]"
    echo
    print_message "${CYAN}" "Options:"
    print_message "${YELLOW}" "  -h, --help${NC}       Show this help message"
    print_message "${YELLOW}" "  -r, --root${NC}       Run the script as root"
    print_message "${YELLOW}" "  -v, --version${NC}    Display script version"
    print_message "${YELLOW}" "  -a, --apply${NC}      Apply Updates"
    print_message "${YELLOW}" "  -c, --clean${NC}      Auto Clean"
    print_message "${YELLOW}" "  -d, --remove${NC}     Auto Remove"
    print_message "${YELLOW}" "  -l, --list${NC}       Display list of available packages to update"
    exit 1
}

# Check for command-line options
while [[ "$#" -gt 0 ]]; do
    case $1 in
    -h | --help) show_help ;;
    -r | --root) RUN_AS_ROOT "$1" ;;
    -v | --version) show_version ;;
    -l | --list) list_security_updates ;;
    -a | --apply) apply_security_updates ;;
    -c | --clean) perform_autoclean ;;
    -d | --remove) perform_autoremove ;;

    *)
        print_message "${RED}" "Unknown option: $1. Use -h or --help for help." >&2
        exit 1
        ;;
    esac
    shift
done

##########################################################################
# Main script logic goes here
##########################################################################
# Check if the script is run with root privileges
RUN_AS_ROOT
# Prints Banner
print_linux_util_banner
# Working Internet Connection
internet_connection
print_message "${BLUE}" "Select an option:"
print_message "${PURPLE}" "1. List available security updates"
print_message "${PURPLE}" "2. Apply security updates"
print_message "${PURPLE}" "3. Run 'apt autoclean'"
print_message "${PURPLE}" "4. Run 'apt autoremove'"
print_message "${PURPLE}" "5. Exit"
echo
read -p "Enter your choice: " choice

case $choice in
1) list_security_updates ;;
2) apply_security_updates ;;
3) perform_autoclean ;;
4) perform_autoremove ;;
5) exit_message ;;
*)
    print_message "${RED}" "Invalid option. Please try again."
    press_enter
    ;;
esac
# Prints exit message on the end of the script
exit_message
