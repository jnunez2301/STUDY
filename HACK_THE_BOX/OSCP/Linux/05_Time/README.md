# Time

A XSS vulnerabilitie machine

## Port 80 | Web

It seems that we have a website that prertyfies our JSON files, interesting thing is that when we click on validate and do anything wrong it will promp with 
```bash
Validation failed: Unhandled Java exception: com.fasterxml.jackson.core.JsonParseException: Unexpected character ('<' (code 60)): expected a valid value (number, String, array, object, 'true', 'false' or 'null')
```

Which could be a **Jackson RCE** Vulnerabilitie with JSON desearialization (ehem it sounds that i know everything but no i just googled `Validation failed: Unhandled Java exception: com.fasterxml.jackson.core.JsonParseException: Unrecognized token 'alert': was expecting ('true', 'false' or 'null')` vulnerabilities lol)

So it seems that it could be [CVE-2017-7525](https://adamcaudill.com/2017/10/04/exploiting-jackson-rce-cve-2017-7525/) so we try it out.

[Jackson Vulnerabilities](https://blog.doyensec.com/2019/07/22/jackson-gadgets.html)


## Spoiler couldnt make it so i had to look for help

[HTB-TIME](https://0xdf.gitlab.io/2021/04/03/htb-time.html)