#!/bin/bash

echo "Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges."
echo "========================================================================================================================="

read -p "What is the IP address of the target machine? " ip_address

echo "Adding $ip_address to ~/.zshrv or ~/.bashrc depending on your shell. Variable will be "\$ip""

if [ -f ~/.zshrc ]; then
    if cat ~/.zshrc | grep -q "export ip"; then
        sed 's/export ip=.*/export ip=$ip_address/' ~/.zshrc
        source ~/.zshrc
        echo "Updated $ip_address in ~/.zshrc"
    else
        echo "export ip=$ip_address" >> ~/.zshrc
        source ~/.zshrc
        echo "Added $ip_address to ~/.zshrc"
    fi
elif [ -f ~/.bashrc ]; then
    if [grep -q "export ip" == 0]; then
        sed 's/export ip=.*/export ip=$ip_address/' ~/.bashrc
        source ~/.bashrc
        echo "Updated $ip_address in ~/.bashrc"
    else
        echo "export ip=$ip_address" >> ~/.bashrc
        source ~/.bashrc
        echo "Added $ip_address to ~/.bashrc"
    fi
else
    echo "No shell configuration file found. Please add the following line to your shell configuration file: export ip=$ip_address"
fi

echo "Setting up the directory structure for the CTF challenges"

read -p "Where do you want the CTF directory to be stored? Format ex. ~/Documents/target_name " ctf_dir

dirTest=$(test -e $ctf_dir)

if [dirTest == 0]; then
    echo "Directory already exists. Continuing..."
    continue
elif [dirTest == 1]; then
    echo "Directory does not exist. Would you like to create it? (y/n)" response
    if [response == "y"]; then
        mkdir -p $ctf_dir && cd $ctf_dir && mkdir scans exploits notes
        echo "Directory structure created. You can find the CTF directory at $ctf_dir"
    elif [response == "n"]; then
        echo "No directory created. Exiting..."
    else
        echo "Invalid response. Please enter y or n"
    fi

read -p "Do you have any hostnames you would like to add? (y/n) " response

if [response == "y"]; then
    read -p "What is the hostname? " hostname
        if [grep -q "$ip_address" == 0]; then
            sed 's/$ip_address.*/$ip_address $hostname/' /etc/hosts
            continue
        else 
            echo "$ip_address $hostname" >> /etc/hosts
            echo "Added $hostname to /etc/hosts"
        fi
elif [response == "n"]; then
    echo "No hostnames to add"
else
    echo "Invalid response. Please enter y or n"
fi
