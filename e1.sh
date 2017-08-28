#!/bin/bash

# Put the IP host in
echo "Please type the IP host"
read a;
echo "Please type the prefix"
read b;
echo "The host IP is: $a/$b"

# Get the host is up and stored it
nmap -sn "$a/$b" | cut -d ' ' -f 5 | sed '/latency)./d' | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > host.txt

# Detect OS
cat host.txt | while read output
do
	nc -zv $output 22 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "$output is up and using Linux"
	else
		nc -zv $output 3389 > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "$output is up and using Win"
		else
		nc -zv $output 22 3389 > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				echo "$output is up but using Unknown OS"
			else
				echo "$output is up but using Unknown OS"
			fi
		fi
	fi
done
