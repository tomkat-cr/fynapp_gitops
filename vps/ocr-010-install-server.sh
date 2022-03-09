#!/bin/bash
# ocr-010-install-server.sh
# 
# https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
# To get OS and VER, the latest standard seems to be /etc/os-release. 
# Before that, there was lsb_release and /etc/lsb-release. 
# Before that, you had to look for different files for each distribution.
# Here's what I'd suggest

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
	if [ "$OS" = "CentOS Linux" ]; then
		if [ "$ID" != "" ]; then
            OS=$ID
		fi
	fi
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

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
