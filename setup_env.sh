#!/bin/bash

printf "Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges.\n"
printf "=========================================================================================================================\n"

sleep 1

read -p "What is the IP address of the target machine?: " ipAddress

printf "Adding $ipAddress to ~/.zshrc or ~/.bashrc depending on your shell. Variable will be "\$ip"\n"

sleep 1

findShell=$(env | grep -w "SHELL" | cut -d "=" -f 2) # Finds the shell being used in the current session
ipString="export ip=*" # Search string for rc files that may be present"


if [ "$findShell" == "/usr/bin/zsh" ] || [ "$findshell" == "/bin/zsh" ]; then # Compares ouput of findShell to discern if zsh or bash is being used
    if grep -q "$ipString" ~/.zshrc; then # Updates variable if it already exists
        sed -i "/export ip=*/c\export ip=$ipAddress" ~/.zshrc
        printf "Upated the ip address variable for your shell to \$ip\n"
    else 
        echo "export ip=$ipAddress" >> ~/.zshrc # Adds variable if it does not exist
        printf "Added $ipAddress to ~/.zshrc\n"
    fi
fi

if [ "$findShell" == "/usr/bin/bash" ] || [ "$findShell" == "/bin/bash" ]; then
    if grep -q "$ipString" ~/.bashrc; then
        sed -i "/export ip=*/c\export ip=$ipAddress" ~/.bashrc
        printf "Updated the ip address variable for your shell to \$ip\n"
    else
        echo "export ip=$ipAddress" >> ~/.bashrc
        printf "Added $ipAddress to ~/.bashrc\n"
    fi
fi

if [ "$findShell" == "" ]; then
    printf "No shell configuration file found. Please add the following line to your shell configuration file using the following command: echo export ip="$ipAddress" >> PATH_TO_YOUR_SHELL"
fi
