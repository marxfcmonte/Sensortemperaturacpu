#!/bin/bash

if [ "$USER" = "root" ]; then
	user=$SUDO_USER
else
	user=$USER
fi

if [ "$USER" != "root" ]; then
	echo "Use comando 'sudo'  ou comando 'su' antes de inicializar o programa."
	exit 1
fi

if ! [ -e "/usr/bin/dialog" ]; then
	echo -e "Dialog não instalado e será instalado...\n"
	apt install -y dialog
fi

if ! [ -e "/usr/bin/shc" ]; then
	echo -e "Shc não instalado e será instalado...\n"
	apt install -y shc libc6-dev
fi

texto="Instalador do Sensor de Temperatura para CPU v 1.8.1 (2025)"
cont="$[${#texto} + 4]"
dialog --title "Desenvolvedor" --infobox "Desenvolvido por Marx F. C. Monte\n
Instalador do Sensor de Temperatura para CPU v 1.8.1 (2025)\n
Para a Distribuição Debian 12 e derivados (antiX 23)" 5 $cont
sleep 3
clear

display_principal(){
	teste=$2 
	if ! [ $teste ]; then
		cont=0
	else
		cont=$teste
	fi
	texto=$1 ; cont1=$[${#texto} + 4 - $cont]
	dialog --colors --infobox "$texto" 3 $cont1
	sleep 3
	clear	
}

menu(){
	texto="SETAS PARA ESCOLHER E ENTER PARA CONFIRMAR" ; cont="$[${#texto} + 4]"
	opcao=$(dialog --title "MENU DE INSTALAÇÃO" --menu "$texto" 10 $cont 3 \
"1" "INSTALAR" \
"2" "REMOVER" \
"3" "SAIR" \
--stdout)
	clear
	pastaj=/usr/bin
	pastaa=/home/$user/.Sensor_temperatura
	case $opcao in
		1)
		display_principal "Instalação sendo iniciada..."
		if [ -d "$pastaa" ]; then
			display_principal "O diretório com a configuração existe..."
		else
			display_principal "O diretório com a configuração será criado..."
			mkdir $pastaa ; chown $user:$user $pastaa
		fi
		cat <<EOF > $pastaj/sensor_temparatura.sh
#!$SHELL

var=\$1

if [ "\$USER" = "root" ]; then
	user=\$SUDO_USER
else
	user=\$USER
fi

pasta_conficuracao=/home/\$user/.Sensor_temperatura

a=\$(cat \$pasta_conficuracao/sensores.conf | tr '\n' ' ')
b=""
p=0
j=""
for i in \$a 
do 
	b=\$(cat \$i | awk '{printf "%.0f", \$1/1000}')
	b="\$b "
	p=\$[p + 1]
done
for k in \$(seq 1 \$p)
do
	if [ "\$var" = "--cpu\$k" ]; then 
		echo "\$(echo \$b | cut -d ' ' -f\$k) °C"
		exit 0
	fi
	if [ \$k -eq \$p ]; then
		if [ "\$var" = "--help" -o "\$var" = "" ]; then
			echo -e "\n	AJUDA\n\n--cpu1 para temperatura do CPU 1.\nAté...\n--cpu\$p para temperatura do CPU \$p."
			exit 0
		else
			echo -e "\n	AJUDA\n\n--cpu1 para temperatura do CPU 1.\nAté...\n--cpu\$p para temperatura do CPU \$p."
			exit 0
		fi
	fi
done
exit 0
EOF
		cat <<EOF > $pastaj/localizador_sensores.sh
#!$SHELL

if [ "\$USER" = "root" ]; then
	user=\$SUDO_USER
else
	user=\$USER
fi

pasta_conficuracao=/home/\$user/.Sensor_temperatura
a=\$(find /sys/devices/ -name 'temp*input' | grep 'core')
echo "\$a" > \$pasta_conficuracao/sensores.conf
chmod +664 \$pasta_conficuracao/sensores.conf ; chown \$user:\$user \$pasta_conficuracao/sensores.conf
exit 0
EOF
		shc -f $pastaj/localizador_sensores.sh -o $pastaj/localizador_sensores
		shc -f $pastaj/sensor_temparatura.sh -o $pastaj/sensor_temparatura
		rm $pastaj/localizador_sensores.sh $pastaj/sensor_temparatura.sh $pastaj/*.sh.x.c
		chmod +x $pastaj/localizador_sensores $pastaj/sensor_temparatura
		cat /home/$user/.desktop-session/startup | grep -q "$pastaj/localizador_sensores &"
		if [ "$?" = "1" ]; then
			sed '/^$/d' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			echo "$pastaj/localizador_sensores &" >> /home/$user/.desktop-session/startup
			chmod +x /home/$user/.desktop-session/startup ; chown $user:$user /home/$user/.desktop-session/startup
			display_principal "Configuração será instalada no Startup..."
		else
			display_principal "A configuração encontrada e não será instalada..."
		fi
		pkill localizador_sensores. ; display_principal "Localizador de sensores de temperatura \Z2iniciado\Zn..." 6
		bash -c "$pastaj/localizador_sensores" & 
		reset ; exit 0
		;;
		2)
		pkill localizador_sensores. ; display_principal "Localizador de sensores de temperatura \Z1finalizado\Zn..." 6
		if [ -e "$pastaj/semsor_temparatura" ]; then
			display_principal "O arquivo Sensor de Temperatura para CPU será removido..." ; rm $pastaj/sensor_temparatura
		else
			display_principal "O diretório Sensor de Temperatura para CPU não encontrado..."
		fi
		if [ -e "$pastaj/localizador_sensores" ]; then
			display_principal "O arquivo Localizador de sensores de temperatura será removido..." ; rm $pastaj/localizador_sensores
		else
			display_principal "O diretório Localizador de sensores de temperatura não encontrado..."
		fi
		if [ -d "$pastaa" ]; then
			display_principal "O diretório /home/$user/.Sensor_temperatura será removido..."
			rm -rf $pastaa
		else
			display_principal "O diretório /home/$user/.Sensor_temperatura não encontrado..."
		fi
		cat /home/$user/.desktop-session/startup | grep -q "$pastaj/localizador_sensores &"
		if [ "$?" = "1" ]; then
			display_principal "Configuração não encontrada.."
		else
			display_principal "A configuração será deletada..."
			awk -F "$pastaj/localizador_sensores &" '{print $1}' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			sed '/^$/d' /home/$user/.desktop-session/startup > /home/$user/.desktop-session/temp.conf 
			mv /home/$user/.desktop-session/temp.conf /home/$user/.desktop-session/startup
			chmod +x /home/$user/.desktop-session/startup ; chown $user:$user /home/$user/.desktop-session/startup
			display_principal "Os arquivos foram removidos..."
		fi
		reset ; exit 0 ;;
		3) display_principal "Saindo do instalador..." ; reset ; exit 0 ;;
		*) display_principal "Instalação cancelada..." ; reset ; exit 0 ;;
	esac	
}

menu
