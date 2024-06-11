#!/bin/bash

print("Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges.")
print("=========================================================================================================================")

read -p "What is the IP address of the target machine? " ip_address

echo "Adding $ip_address to ~/.zshrv or ~/.bashrc depending on your shell. Variable will be "\$ip""

if [ -f ~/.zshrc ]; then
    if cat ~/.zshrc | grep -q "export ip"; then
        sed 's/export ip=.*/export ip=$ip_address/' ~/.zshrc
        continue
    fi
    echo "export ip=$ip_address" >> ~/.zshrc
    echo "Added $ip_address to ~/.zshrc"
elif [ -f ~/.bashrc ]; then
    if cat ~/.bashrc | grep -q "export ip"; then
        sed 's/export ip=.*/export ip=$ip_address/' ~/.bashrc
        continue
    fi
    echo "Added $ip_address to ~/.bashrc"
else
    echo "No shell configuration file found. Please add the following line to your shell configuration file: export ip=$ip_address"
fi

echo "Setting up the directory structure for the CTF challenges"

read -p "Where do you want the CTF directory to be stored? " ctf_dir

mkdir -p $ctf_dir && cd $ctf_dir && mkdir scans exploits notes

echo "Directory structure created. You can find the CTF directory at $ctf_dir"

read -p "Do you have any hostnames you would like to add? (y/n) " response

if response == "y"; then
    read -p "What is the hostname? " hostname
        if cat /etc/hosts | grep -q "$ip_address"; then
            sed 's/$ip_address.*/$ip_address $hostname/' /etc/hosts
            continue
        else 
            echo "$ip_address $hostname" >> /etc/hosts
            echo "Added $hostname to /etc/hosts"
else if response == "n"; then
    echo "No hostnames to add"
else
    echo "Invalid response. Please enter y or n"
fi