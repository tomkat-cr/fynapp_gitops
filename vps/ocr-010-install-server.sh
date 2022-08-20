#!/bin/bash
# File: "fynapp_gitops/scripts/get_os_name_type.sh"
# Creacion del usuario ubuntu/centos/ocrusr, grupo ocrgroup, aregarlo al grupo de los sudoers y al grupo docker.
# IMPORTANTE: Este script se debe ejecutar en el Server.
# 2022-03-09 | CR

# Get the distro name and type
. "../scripts/get_os_name_type.sh" ;
OS=$OS_NAME ;
VER=$OS_VERSION ;

echo "";
echo "CREACION DEL USUARIO PRINCIPAL CON BASE EN LA DISTRO ACTUAL";
echo "Distro [$OS] versión [$VER]";
echo "";

export OS=$(echo "$OS" | awk '{print tolower($0)}') ;
export ocr_user=$OS ;
if [ "$1" != "" ]; then
    export ocr_user=$1 ;
fi
export ocr_group="ocrgroup" ;
if [ "$OS" = "debian" ]; then
    export sudoers_group="sudo" ;
else
    export sudoers_group="wheel" ;
fi
export docker_group="docker" ;

echo "El usuario a crear es [$ocr_user] en el grupo [$ocr_group].";
echo "Adicionalmente se va a agregar a los grupos: $sudoers_group, $docker_group";
echo "Se le va a pedir una contraseña para el usuario $ocr_user.";
echo "Recuerde por favor tomar nota de esa contraseña.";
echo "";
read -p "¿De acuerdo con estos datos (s/n)? " answer ;#
if [ $answer = "s" ]
then
	# Se crea grupo "ocrgroup"
	sudo groupadd $ocr_group ;
	# Por si acaso, se crea grupo "docker"
	sudo groupadd docker ;
	# Se crea usuario "ubuntu" en el grupo "ocrgroup"
	sudo useradd -g $ocr_group -d /home/$ocr_user -m $ocr_user ;
	# Se agrega al grupo "docker"
	sudo usermod -a -G $docker_group $ocr_user;
	# Crear directorio ~/Downloads
	sudo mkdir -p /home/$ocr_user/Downloads ;
	# Allow members of group sudo to execute any command
	# En ubuntu, el grupo es "sudo", en RHEL es "wheel" y se debe activar la opcion con "visudo"
	# Para mas informacion, ver:
	# 2.3. Configuring sudo Access (sudoers)
	# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux_OpenStack_Platform/2/html/Getting_Started_Guide/ch02s03.html
	#
	sudo usermod -a -G $sudoers_group $ocr_user;
	# Cambiar contraseña del usuario que se esta creando
	sudo passwd $ocr_user;
	echo "";
	echo "Listo... Usuario [$ocr_user] y grupo [$ocr_group] han sido creados.";
	echo "El usuario [$ocr_user] pertenece a estos grupos:";
	groups $ocr_user ;
	echo "";
fi
