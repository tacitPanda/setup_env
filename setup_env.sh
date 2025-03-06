#!/bin/bash

RED=$(tput setaf 1)
REDBACK=$(tput setab 1)
GREEN=$(tput setaf 2)
BOLDRED=$(tput setaf 1; tput bold)
NORMAL=$(tput sgr0)

set_ip=0
set_hosts=0
set_folder=0
ip_value=""
hosts_value=""
folder_value=""

usage() {
    echo "Usage: $0 [-i IP] [-n hosts/subdomains] [-d directory]"

    echo "  -i <value>   Set an IP address as the target"
    echo "  -n <host>    Add a host entry to /etc/hosts"
    echo "  -d <directory>    Setup a directory for organization of findings, exploits, scripts, and files" 
    exit 1
}

while getopts "i:n:d:" opt; do
    case "$opt" in
        i)
            set_ip=1
            ip_value="$OPTARG"
            ;;
        n)
            set_hosts=1
            hosts_value="$OPTARG"
            ;;
        d)
            set_folder=1
            folder_value="$OPTARG"
            ;;
        ?) usage ;;
    esac
done

if [[ $set_ip -eq 1 ]]; then
    ipString="export ip="
    findShell=$(env | grep -w "SHELL" | cut -d "=" -f 2)

    if [ "$findShell" == "/usr/bin/zsh" ] || [ "$findShell" == "/bin/zsh" ]; then # Compares ouput of findShell to discern if zsh or bash is being used. I feel like this could be done more efficiently...
        if grep -q "$ipString" ~/.zshrc; then 
            sed -i "/export ip=*/c\export ip=$ip_value" ~/.zshrc # Updates variable if it already exists
            sleep 1
            printf "Updated the ip address variable for your shell ~/.zshrc to ${GREEN}$ip_value${NORMAL}. The variable has been set to ${GREEN}\$ip${NORMAL}\n"
        else 
            echo "export ip=$ip_value" >> ~/.zshrc # Adds variable if it does not exist
            sleep 1
            printf "Added ${GREEN}$ip_value${NORMAL} to ~/.zshrc. The variable is ${GREEN}\$ip${NORMAL}\n"
        fi
    fi

    if [ "$findShell" == "/usr/bin/bash" ] || [ "$findShell" == "/bin/bash" ]; then # Does the same as above but for bash
        if grep -q "$ipString" ~/.bashrc; then
            sed -i "/export ip=*/c\export ip=$ip_value" ~/.bashrc
            sleep 1
            printf "Upated the ip address variable for your shell ~/.bashrc to ${GREEN}$ip_value${NORMAL}. The variable has been set to ${GREEN}\$ip${NORMAL}\n"
        else
            echo "export ip=$ip_value" >> ~/.bashrc
            sleep 1
            printf "Added ${GREEN}$ip_value${NORMAL} to ~/.bashrc. The variable is ${GREEN}\$ip${NORMAL}\n"
        fi
    fi

    if [ "$findShell" == "" ]; then # Prompts user with the command to add the variable manually if no shell was found
    printf "${REDBACK}No shell configuration file found.${NORMAL} Please add the following line to your shell configuration file using the following command: echo "export ip=$ipAddress" >> PATH_TO_yOUR_SHELL_RC"
    fi
fi

if [[ $set_hosts -eq 1 ]]; then
    read -rp "You will be prompted for your sudo password as adding hostnames requires root privileges. Press enter to continue."
    
    if grep -q "$ip_value" /etc/hosts; then
        sudo sed -i "/^$ip_value\s/c\\$ip_value $hosts_value" /etc/hosts
    else
        echo "$ip_value"$'\t'"$hosts_value" | sudo tee -a /etc/hosts
    fi
    printf "Added ${GREEN}$hosts_value${NORMAL} to your /etc/hosts file.\n"
fi

if [[ $set_folder -eq 1 ]]; then
    mkdir -p ./"$folder_value"/{scans,notes,scripts,exploits} # Creates folder and subdirectories in the current directory
    printf "Created ${GREEN}$folder_value${NORMAL} folder with the following subdirectories: ${GREEN}scans, notes, scripts, and exploits${NORMAL}\n"
fi