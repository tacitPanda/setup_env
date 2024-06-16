#!/bin/bash

printf "Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges.\n"
printf "ATTENTION: In order for this script to work you must run source ~/.zshrc or source ~/.bashrc after running this script.\nIf you are using a different shell, please run the appropriate command to source your shell configuration file.\n"
printf "Alternatively you can run this script using the command, which will change your current sessions variables: source setup_env.sh\n"
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
        source ~/.zshrc
        printf "Upated the ip address variable for your shell to \$ip\n"
    else 
        echo "export ip=$ipAddress" >> ~/.zshrc # Adds variable if it does not exist
        source ~/.zshrc
        printf "Added $ipAddress to ~/.zshrc\n"
    fi
fi

if [ "$findShell" == "/usr/bin/bash" ] || [ "$findShell" == "/bin/bash" ]; then # Does the same as above but for bash
    if grep -q "$ipString" ~/.bashrc; then
        sed -i "/export ip=*/c\export ip=$ipAddress" ~/.bashrc
        sleep 1
        source ~/.bashrc
        printf "Updated the ip address variable for your shell to \$ip\n"
    else
        echo "export ip=$ipAddress" >> ~/.bashrc
        sleep 1
        source ~/.bashrc
        printf "Added $ipAddress to ~/.bashrc\n"
    fi
fi

if [ "$findShell" == "" ]; then # Prompts user with the command to add the variable manually if no shell was found
    printf "No shell configuration file found. Please add the following line to your shell configuration file using the following command: echo "export ip=$ipAddress" >> PATH_TO_YOUR_SHELL_RC"
fi

read -p "Would you like to organize a folder for this challenge? (Y/N): " organizeFolder

if [ "$organizeFolder" == "Y" ]; then
    read -p "What is the name of the folder you would like to create?: " folderName
    read -p "Do you want to create this folder in a directory other than the current directory? (Y/N): " otherDirectory

    if [ "$otherDirectory" == "Y" ]; then
        read -p "What is the path to the directory you would like to create the folder in?: " directoryPath
        mkdir $directoryPath/$folderName/{scans,notes,scripts,exploits}
        printf "Created $folderName in $directoryPath with the following subdirectories: scans, notes, scripts, and exploits\n"
    else
        mkdir $folderName/{scans,notes,scripts,exploits}
        printf "Created $folderName with the following subdirectories: scans, notes, scripts, and exploits\n"
    fi
elif [ "$organizeFolder" == "N" ]; then
    printf "Skipping folder organization\n"
fi

read -p "Lastly, do you have a hostname for the target machine? (Y/N): " hostnameChoice

if [ "$hostnameChoice" == "Y" ]; then
    read -p "What is the hostname of the target machine? If you have multiple seperate them by a space: " hostname

    printf "Adding $hostname to your /etc/hosts file\n"

    echo "ipAddress $hostname" >> /etc/hosts
fi

printf "REMEMBER: If you DID NOT run this script using 'source setup_env.sh' Your IP variable WILL NOT WORK\n Use source ~/NAME_OF_YOUR_CONFIG to finalize\nSetup complete. Remember, when all else fails, ENUMERATE!\n"
