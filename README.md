## setup_env

Just a quick script to get some variables setup and some files modified to make life a little easier when doing CTFs. With one line and a few flags you can setup your environment with an IP variable, Hostnames, and a working Directory for organization.

#### How to run

Clone repository

`chmod +x setup_env.sh`

`./setup_env.sh`

Alternatively you can mv the script to a folder located in your $PATH

**NOTE: To have the IP variable immediately available in your current shell, you have two options:**
1. **Source the script:** `source ./setup_env.sh -i 10.10.10.10` or `. ./setup_env.sh -i 10.10.10.10`
2. **Execute normally and then source your rc file:** `./setup_env.sh -i 10.10.10.10` then `source ~/.zshrc` or `source ~/.bashrc`

If you add the script to your $PATH and run it as a command, you'll need to manually run `source ~/.zshrc` or `source ~/.bashrc` after execution to load the IP variable.

#### Usage

-  -i :   Set an IP address as the target
-  -n :   Add a host entry to /etc/hosts. Multiple hostnames can be added using double quotes. **The IP must be set using the -i flag first.** Example: `./setup_env.sh -i 10.10.10.10 -n "test.htb www.test.htb"`
-  -d :   Setup a directory for organization of findings, exploits, scripts, and files
-  -h :   Displays this help message

#### Examples

Set IP and add hostnames:
```bash
./setup_env.sh -i 10.10.10.10 -n test.htb
```

Set IP and add multiple hostnames:
```bash
./setup_env.sh -i 10.10.10.10 -n "test.htb www.test.htb admin.test.htb"
```

Setup everything at once:
```bash
./setup_env.sh -i 10.10.10.10 -n test.htb -d test_machine
```

#### Features

- Sets IP variable for easy usage with various tools (automatically exports to current shell)
- Establishes a working directory with clearly named subdirectories for proper organization
- Establishes Hostnames in /etc/hosts file for proper redirection and navigation
- Automatically backs up /etc/hosts before making changes
