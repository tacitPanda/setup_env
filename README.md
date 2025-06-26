## setup_env

Just a quick script to get some variables setup and some files modified to make life a little easier when doing CTFs. With one line and a few flags you can setup your environment with a IP variable, Hostnames, and a working Directory for organization.

#### How to run

Clone repository

`chmod +x setup_env.sh`

`./setup_env.sh`

Alternatively you can mv the script to a folder located in your $PATH

**NOTE: In order to have variables be added to the parent shell you must run the script using source setup_env.sh or . setup_env.sh. This WILL NOT WORK if you add the script to your $PATH and make it executable. If you prefer to add it to your $PATH once the script is done and setup is complete please run `source ~/.zshrc` or `source ~/.bashrc` to finalize the variable changes**

#### Usage

-  -i :   Set an IP address as the target
-  -n :   Add a host entry to /etc/hosts. Multiple hostnames can be added using double quotes. If you did not set an IP as a variable you will be prompted to do so. 
-  -d :   Setup a directory for organization of findings, exploits, scripts, and files
-  -h :   Displays this help message

#### Features

- Sets IP variable for easy usage with various tools
- Establishes a working directory with clearly named subdirectories for proper organziation
- Establishes Hostnames in /etc/hosts file for proper redirection and navigation