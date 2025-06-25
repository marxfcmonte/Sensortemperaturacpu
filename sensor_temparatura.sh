#!/bin/bash

var=$1

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Sensor_temperatura

a=$(cat $pasta_conficuracao/sensores.conf | tr '\n' ' ')
b=""
p=0
j=""
for i in $a 
do 
	b=$(cat $i | awk '{printf "%.0f", $1/1000}')
	b="$b "
	p=$[p + 1]
done
for k in $(seq 1 $p)
do
	if [ "$var" = "--cpu$k" ]; then 
		echo "$(echo $b | cut -d ' ' -f$k) °C"
		exit 0
	fi
	if [ $k -eq $p ]; then
		if [ "$var" = "--help" -o "$var" = "" ]; then
			echo -e "\n	AJUDA\n\n--cpu1 para temperatura do CPU 1.\nAté...\n--cpu$p para temperatura do CPU $p."
			exit 0
		else
			echo -e "\n	AJUDA\n\n--cpu1 para temperatura do CPU 1.\nAté...\n--cpu$p para temperatura do CPU $p."
			exit 0
		fi
	fi
done
