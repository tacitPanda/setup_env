#!/bin/bash

printf "Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges.\n"
printf "=========================================================================================================================\n"

read -p "What is the IP address of the target machine?: " ip_address

printf "Adding $ip_address to ~/.zshrc or ~/.bashrc depending on your shell. Variable will be "\$ip"\n"

findShell=$(env | grep -w "SHELL" | cut -d "=" -f 2)
ipString="export ip="

while true; do

    if [ $findShell = "/usr/bin/zsh" ]; then
        if grep -q "$ip_string" ~/.zshrc; then
            sed -i '/export ip=*/c\export ip=\"$ip_address\"\' ~/.zshrc
            printf "Upated the ip address variable for your shell to \$ip\n"
        else
            echo "export ip= $ip_address" >> ~/.zshrc
            printf "Added $ip_address to ~/.zshrc\n"
        fi
    fi

    if [ $findShell = "/usr/bin/bash" ]; then
        if grep -q "$ip_string" ~/.bashrc; then
            sed -i '/export ip=*/c\export ip=\"$ip_address\"\' ~/.bashrc
            printf "Updated the ip address variable for your shell to \$ip\n"
        else
            echo "export ip= $ip_address" >> ~/.bashrc
            printf "Added $ip_address to ~/.bashrc\n"
        fi
    fi

    if [ $findShell = "" ]; then
        printf "No shell configuration file found. Please add the following line to your shell configuration file using the following command: echo export ip=\"$ip_address\" >> PATH_TO_YOUR_SHELL"
    fi