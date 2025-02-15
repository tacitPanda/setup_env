## setup_env

Just a quick script to get some variables setup and some files modified to make life a little easier when doing CTFs. With one line and a few flags you can setup your environment with a IP variable, Hostnames, and a working Directory for organization.

#### How to run 

Clone repository

`chmod +x setup_env.sh`

`./setup_env.sh`

Alternatively you can mv the script to a folder located in your $PATH

**Once the script is done and setup is complete please run `source ~/.zshrc` or `source ~/.bashrc` to finalize the variable changes**

#### Usage:

  -i <value>   Set an IP address as the target
  -n <host>    Add a host entry to /etc/hosts
  -d <directory>    Setup a directory for organization of findings, exploits, scripts, and files


#### Features ####

- Sets IP variable for easy usage with various tools
- Establishes a working directory with clearly named subdirectories for proper organziation
- Establishes Hostnames in /etc/hosts file for proper redirection and navigation
