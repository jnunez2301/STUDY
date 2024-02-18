#!/bin/bash

# Download JDK 1.8
echo "[+] Downloading Java JDK 1.8"

wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz

# Extract it
mkdir ~/jdk; tar -xvzf ./jdk-8u202-linux-x64.tar.gz -C ~/jdk/

# set JAVA_HOME
export JAVA_HOME=~/jdk/jdk1.8.0_202

# set PATH
export PATH=~/jdk/jdk1.8.0_202/bin:$PATH

echo "[-] Instalation file removed"

rm ./jdk-8u202-linux-x64.tar.gz 