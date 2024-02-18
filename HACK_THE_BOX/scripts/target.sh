#!/bin/sh

# Usage: Adding your values on the widget at the end of 
# /path/to/target.sh MachineName TargetIp
# /path/to/target.sh Machine 192.168.1.1

machine=$1
ip=$2

# Verify if there is an ip
if [ "${ip}" != "" ]; then
  printf "<txt>${machine}  - ${ip}</txt>"
  printf "<tool>TARGET IP</tool>"
else
  printf "<txt>No victim yet u.u</txt>"
fi