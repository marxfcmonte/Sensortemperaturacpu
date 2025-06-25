#!/bin/bash

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

pasta_conficuracao=/home/$user/.Sensor_temperatura
a=$(find /sys/devices/ -name 'temp*input' | grep 'core')
echo "$a" > $pasta_conficuracao/sensores.conf
chmod +664 $pasta_conficuracao/sensores.conf ; chown $user:$user $pasta_conficuracao/sensores.conf
exit 0
