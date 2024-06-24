#!/bin/bash

RED=$(tput setaf 1)
REDBACK=$(tput setab 1)
GREEN=$(tput setaf 2)
BOLDRED=$(tput setaf 1; tput bold)
NORMAL=$(tput sgr0)

printf "Welcome to the setup environment script. The purpose of this script is to configure your environment for CTF challenges.\n"
printf "${REDBACK}ATTENTION:${NORMAL}In order for this script to work you must run source ~/.zshrc or source ~/.bashrc after running this script.\n"
printf "If you are using a different shell, please run the appropriate command to source your shell configuration file.\n"
printf "=========================================================================================================================\n"

sleep 1

read -rp "What is the IP address of the target machine?: " ipAddress

printf "Adding ${GREEN}$ipAddress${NORMAL} to ~/.zshrc or ~/.bashrc depending on your shell. Variable will be "\$ip"\n"

sleep 1

findShell=$(env | grep -w "SHELL" | cut -d "=" -f 2) # Finds the shell being used in the current session
ipString="export ip=" # The search string for the ip variableif it was presently set. Helps with using the script and updating more than once :)


if [ "$findShell" == "/usr/bin/zsh" ] || [ "$findShell" == "/bin/zsh" ]; then # Compares ouput of findShell to discern if zsh or bash is being used. I feel like this could be done more efficiently...
    if grep -q "$ipString" ~/.zshrc; then 
        sed -i "/export ip=*/c\export ip=$ipAddress" ~/.zshrc # Updates variable if it already exists
        sleep 1
        printf "Upated the ip address variable for your shell ~/.zshrc to ${GREEN}$ipAddress${NORMAL}. The variable has been set to ${GREEN}\$ip${NORMAL}\n"
    else 
        echo "export ip=$ipAddress" >> ~/.zshrc # Adds variable if it does not exist
        sleep 1
        printf "Added ${GREEN}$ipAddress${NORMAL} to ~/.zshrc. The variable is ${GREEN}\$ip${NORMAL}\n"
    fi
fi

if [ "$findShell" == "/usr/bin/bash" ] || [ "$findShell" == "/bin/bash" ]; then # Does the same as above but for bash
    if grep -q "$ipString" ~/.bashrc; then
        sed -i "/export ip=*/c\export ip=$ipAddress" ~/.bashrc
        sleep 1
        printf "Upated the ip address variable for your shell ~/.bashrc to ${GREEN}$ipAddress${NORMAL}. The variable has been set to ${GREEN}\$ip${NORMAL}\n"
    else
        echo "export ip=$ipAddress" >> ~/.bashrc
        sleep 1
        printf "Added ${GREEN}$ipAddress${NORMAL} to ~/.bashrc. The variable is ${GREEN}\$ip${NORMAL}\n"
    fi
fi

if [ "$findShell" == "" ]; then # Prompts user with the command to add the variable manually if no shell was found
    printf "${REDBACK}No shell configuration file found.${NORMAL} Please add the following line to your shell configuration file using the following command: echo "export ip=$ipAddress" >> PATH_TO_yOUR_SHELL_RC"
fi

read -rp "Would you like to organize a folder for this challenge? (y/n): " organizeFolder

if [ "$organizeFolder" == "y" ]; then
    read -rp "What is the name of the folder you would like to create?: " folderName
    read -rp "Do you want to create this folder in a directory other than the current directory? (y/n): " otherDirectory
    while true; do
        if [ "$otherDirectory" == "y" ]; then
            read -rp "What is the path to the directory you would like to create the folder in? Please use an ${REDBACK}absolute path${NORMAL}: " directoryPath
            if [ -d "$directoryPath" ]; then
                mkdir -p "$directoryPath/$folderName"/{scans,notes,scripts,exploits} # Creates the folder and subdirectories based on path provided from directoryPath
                printf "Created ${GREEN}$folderName${NORMAL} in ${GREEN}$directoryPath${NORMAL} with the following subdirectories: ${GREEN}scans, notes, scripts, and exploits${NORMAL}\n"
                break
            else
                printf "${REDBACK}Directory does not exist!${NORMAL} Try again.\n"
            fi    
        else
            mkdir -p ./"$folderName"/{scans,notes,scripts,exploits} # Creates folder and subdirectories in the current directory
            printf "Created ${GREEN}$folderName${NORMAL} folder with the following subdirectories: ${GREEN}scans, notes, scripts, and exploits${NORMAL}\n"
            break
        fi
    done
fi

if [ "$organizeFolder" == "n" ]; then
    printf "${RED}No folder created${NORMAL}\n"
fi

read -rp "Lastly, do you have a hostname for the target machine? (y/n): " hostnameChoice

if [ "$hostnameChoice" == "y" ]; then
    read -rp "What is the hostname of the target machine? ${RED}If you have multiple seperate them by a space:${NORMAL} " hostname
    read -rp "You will be prompted for your sudo password as this operation requires root privileges. Press enter to continue.\n"
    
    if grep -q "$ipAddress" /etc/hosts; then
        sudo sed -i "/^$ipAddress\s/c\\$ipAddress $hostname" /etc/hosts
    else
        echo "$ipAddress $hostname" | sudo tee -a /etc/hosts
    fi
    printf "Added ${GREEN}$hostname${NORMAL} to your /etc/hosts file.\n"
fi

printf "${REDBACK}REMEMBER:${NORMAL} Use source ~/NAME_OF_YOUR_CONFIG to finalize variables set for your environment.\n${GREEN}Setup complete!${NORMAL} Remember, when all else fails, ENUMERATE!\n"