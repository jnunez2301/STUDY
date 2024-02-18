
# Tentacles

This machine reports that 22/tcp OpenSSH, 53/tcp which is running on ISC BIND 9.11.20 (Red Hat),
88/tcp which is running on MIT Kerberos and 3128/tcp Squid HTTP proxy 4.11

## 3128/TCP Squid http proxy

[3128 TCP http proxy | Pentesting](https://book.hacktricks.xyz/network-services-pentesting/3128-pentesting-squid)

```bash
curl --proxy http://10.10.10.224:3128 http://10.10.10.224
```
We get a response but lets take a look at `realcorp.htb` which was reported by nmap that was running on
port 3128, we take a look and we find an error and this email **j.nakazawa@realcorp.htb**


Lets try to enum sub directories and sub domains.

```bash
dirsearch -u http://realcorp.htb:3128 -e*
```
*Nothing found* Lets try with gobuster

[Squid Pivoting Open Port Scanner](https://github.com/aancw/spose.git)

Lets try it out *Nothing lets move on*
