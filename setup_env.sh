#!/bin/bash

REDBACK=$(tput setab 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

set_ip=0
set_hosts=0
set_folder=0
ip_value=""
hosts_value=""
folder_value=""

validate_ip() {
    local ip="$1"
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ $ip =~ $regex ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if ((octet < 0 || octet > 255)); then
                echo "Invalid IP: Octet out of range"
                return 1
            fi
        done
        echo "Valid IP"
        return 0
    else
        echo "Invalid IP: Format error"
        return 1
    fi
}

usage() {
    echo "Usage: $0 [-i IP] [-n hosts/subdomains] [-d directory]"

    echo "  -i  Set an IP address as the target"
    echo "  -n  Add a host entry to /etc/hosts"
    echo "  -d  Setup a directory for organization of findings, exploits, scripts, and files. Sub folders are created automatically"
    echo "  -h  Displays this message"
    exit 1
}

while getopts "i:n:d:h" opt; do
    case "$opt" in
        i)
            set_ip=1
            ip_value="$OPTARG"
            if ! validate_ip "$ip_value"; then
                exit 1
            fi
            ;;
        n)
            set_hosts=1
            hosts_value="$OPTARG"
            ;;
        d)
            set_folder=1
            folder_value="$OPTARG"
            ;;

        h) usage
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
            printf "Updated the ip address variable for your shell ~/.zshrc to %s%s%s. The variable has been set to %s%s%s\n" \
              "$GREEN" "$ip_value" "$NORMAL" "$GREEN" "$ip" "$NORMAL"
        else 
            echo "export ip=$ip_value" >> ~/.zshrc # Adds variable if it does not exist
            printf "Added %s%s%s to ~/.zshrc. The variable is %s%s%s\n" \
              "$GREEN" "$ip_value" "$NORMAL" "$GREEN" "$ip" "$NORMAL"  
        fi
    fi

    if [ "$findShell" == "/usr/bin/bash" ] || [ "$findShell" == "/bin/bash" ]; then # Does the same as above but for bash
        if grep -q "$ipString" ~/.bashrc; then
            sed -i "/export ip=*/c\export ip=$ip_value" ~/.bashrc
            printf "Upated the ip address variable for your shell ~/.bashrc to %s%s%s. The variable has been set to %s%s%s\n" \
              "$GREEN" "$ip_value" "$NORMAL" "$GREEN" "$ip" "$NORMAL"
        else
            echo "export ip=$ip_value" >> ~/.bashrc
            printf "Added %s%s%s to ~/.bashrc. The variable is %s%s%s\n" \
              "$GREEN" "$ip_value" "$NORMAL" "$GREEN" "$ip" "$NORMAL"
        fi
    fi

    if [ "$findShell" == "" ]; then # Prompts user with the command to add the variable manually if no shell was found
    printf "%sNo shell configuration file found.%s Please add the following line to your shell configuration file using the following command: echo \"export ip=%s\" >> PATH_TO_YOUR_SHELL_RC" \
      "$REDBACK" "$NORMAL" "$ip_value"
    fi
fi

if [[ $set_hosts -eq 1 ]]; then
    read -rp "You will be prompted for your sudo password as adding hostnames requires root privileges. Press enter to continue."
    
    if grep -q "$ip_value" /etc/hosts; then
        sudo sed -i "/^$ip_value\s/c\\$ip_value $hosts_value" /etc/hosts
    else
        echo "$ip_value"$'\t'"$hosts_value" | sudo tee -a /etc/hosts
    fi
    printf "Added %s%s%s to your /etc/hosts file.\n" \
      "$GREEN" "$hosts_value" "$NORMAL"
fi

if [[ $set_folder -eq 1 ]]; then
    mkdir -p ./"$folder_value"/{scans,notes,scripts,exploits} # Creates folder and subdirectories in the current directory
    printf "Created %s%s%s folder with the following subdirectories: %sscans, notes, scripts, and exploits%s\n" \
      "$GREEN" "$folder_value" "$NORMAL" "$GREEN" "$NORMAL"
fi