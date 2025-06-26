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
    echo "  -d  Setup a directory for organizing findings, exploits, scripts, and files"
    echo "  -h  Display this help message"
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
        h)
            usage
            ;;
        ?)
            usage
            ;;
    esac
done

# Attempt to source ip from shell config
if [[ $set_ip -eq 0 ]]; then
    shell_rc=""
    shell_type=$(basename "$SHELL")

    if [[ $shell_type == "zsh" ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ $shell_type == "bash" ]]; then
        shell_rc="$HOME/.bashrc"
    fi

    if [[ -f "$shell_rc" ]]; then
        ip_line=$(grep -E '^export ip=' "$shell_rc")
        if [[ -n "$ip_line" ]]; then
            ip_value=$(echo "$ip_line" | cut -d '=' -f2)
            if validate_ip "$ip_value"; then
                echo "Found IP in $shell_rc: $ip_value"
            else
                echo "Found IP in $shell_rc, but it's invalid. Prompting for new one..."
                set_ip=1
            fi
        else
            echo "No export ip= line found in $shell_rc"
            set_ip=1
        fi
    else
        echo "Shell config file not found. Cannot read IP from it."
        set_ip=1
    fi
fi

# Update shell config if IP was manually provided or missing
if [[ $set_ip -eq 1 ]]; then
    if [[ -z "$ip_value" ]]; then
        read -rp "Enter an IP address to set: " ip_value
        if ! validate_ip "$ip_value"; then
            echo "Invalid IP. Exiting."
            exit 1
        fi
    fi

    shell_rc=""
    shell_type=$(basename "$SHELL")

    if [[ $shell_type == "zsh" ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ $shell_type == "bash" ]]; then
        shell_rc="$HOME/.bashrc"
    fi

    if [[ -n "$shell_rc" && -f "$shell_rc" ]]; then
        if grep -q '^export ip=' "$shell_rc"; then
            sed -i "/^export ip=/c\export ip=$ip_value" "$shell_rc"
            echo "Updated export ip= to $ip_value in $shell_rc"
        else
            echo "export ip=$ip_value" >> "$shell_rc"
            echo "Added export ip=$ip_value to $shell_rc"
        fi
    else
        printf "%sNo shell config file detected. Add the following line manually:\necho \"export ip=%s\" >> ~/.zshrc or ~/.bashrc\n%s" "$REDBACK" "$ip_value" "$NORMAL"
    fi
fi

if [[ $set_hosts -eq 1 ]]; then
    if [[ -z "$ip_value" ]]; then
        echo "IP value is not set. Cannot continue with /etc/hosts update."
        exit 1
    fi

    read -rp "You will be prompted for your sudo password. Press enter to continue."
    sudo -v || exit 1

    backup_file="/etc/hosts.bak"

    if [ -e "$backup_file" ]; then
        read -p "Backup of /etc/hosts exists. Overwrite? (y/N): " answer
        if [[ "$answer" =~ ^[Yy] ]]; then
            sudo cp /etc/hosts "$backup_file"
            echo "Backup overwritten."
        else
            echo "Skipping backup."
        fi
    else
        sudo cp /etc/hosts "$backup_file"
        echo "Backup created."
    fi

    if grep -q -E "^$ip_value[[:space:]]+" /etc/hosts; then
        sudo sed -i -E "s|^$ip_value[[:space:]]+.*|$ip_value $hosts_value|" /etc/hosts
        echo "Updated existing entry for $ip_value"
    else
        echo -e "$ip_value\t$hosts_value" | sudo tee -a /etc/hosts > /dev/null
        echo "Added new entry for $ip_value"
    fi

    printf "Added %s%s%s to your /etc/hosts file.\n" "$GREEN" "$hosts_value" "$NORMAL"
fi

if [[ $set_folder -eq 1 ]]; then
    mkdir -p ./"$folder_value"/{scans,notes,scripts,exploits}
    printf "Created %s%s%s folder with subdirectories: %sscans, notes, scripts, exploits%s\n" \
        "$GREEN" "$folder_value" "$NORMAL" "$GREEN" "$NORMAL"
fi
