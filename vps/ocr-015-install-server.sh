#!/bin/bash
# File: fynapp_gitops/vps/ocr-015-install-server.sh
# Generar llave privada de acceso al servidor.
# 2022-03-07 | CR

createKey=1;
if [ "$1" = "" ]; then
    echo "";
    echo "Se requiere el 1er parametro: Nombre del usuario.";
    echo "Por ejemplo: ocrusr";
    createKey=0;
fi
if [ "$2" = "" ]; then
    echo "";
    echo "Se requiere el 2do. parametro: Nombre/IP del server.";
    echo "Por ejemplo: vps.fynapp.com";
    createKey=0;
fi

echo "";

if [ $createKey -eq 1 ]; then

    VPS_USER=$1 ;
    VPS_NAME=$2 ;
    VPS_ID_RSA_FILENAME="id_rsa_${VPS_USER}_${VPS_NAME}" ;

    # Dentro de nuestro PC local, entrar a Poweshell o CMD, y crear una llave con el comando:

    echo "CREACION DE LLAVE PUBLICA/PRIVADA PARA SERVER REMOTO" ;
    echo "" ;
    echo "Este script se debe ejecutar desde su PC local, no en el Server."
    echo "" ;
    echo "Usuario: ${VPS_USER}" ;
    echo "Server: ${VPS_NAME}" ;
    echo "" ;
    echo "El siguiente paso va a crear las llaves." ;
    echo "LLave a ser creada: ${VPS_ID_RSA_FILENAME}" ;
    echo "" ;
    echo "IMPORTANTE: A todo lo que pregunte, presionar ENTER." ;

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    ssh-keygen -b 4096 ;

    echo "" ;
    echo "Se deben haber creado dos imágenes: una pública 'id_rsa.pub' y una privada 'id_rsa'" ;
    echo "En el directorio [~/$USER/.ssh] de nuestro usuario." ;
    echo "Esos archivos seran renombrados a: ${VPS_ID_RSA_FILENAME}" ;

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    cd ~/.ssh ;
    mv id_rsa ${VPS_ID_RSA_FILENAME} ;
    mv id_rsa.pub ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    echo "A continuacion va a pedir la constraseña de Super usuario pra cambiar los atributos de las llaves:"

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    sudo chmod 600 ${VPS_ID_RSA_FILENAME} ;
    sudo chmod 600 ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    echo "Y así quedaron las llaves:"
    echo "" ;

    ls -lah ${VPS_ID_RSA_FILENAME} ;
    ls -lah ${VPS_ID_RSA_FILENAME}.pub ;

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    echo "" ;
    echo "Ahora se subirá la llave pública al server mediante 'ssh-copy-id'." ;
    echo "ssh-copy-id crea un archivo authorized-keys en /home/usuario/.sh/ del servidor destino." ;

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    ssh-copy-id -i ${VPS_ID_RSA_FILENAME}.pub ${VPS_USER}@${VPS_NAME} ;

    echo "" ;
    echo "Si se queja que el footprint del server cambio:" ;
    echo "ERROR: @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @" ;
    echo "" ;
    echo "Ejecutar el comando:" ;
    echo "sudo nano ~/.ssh/known_hosts" ;
    echo "" ;
    echo "Y eliminar las líneas que tengan el IP y/o dominio del server." ;

    echo "" ;
    echo "Ahora se hace la prueba de conexión al servidor con las llaves creadas." ;

    echo "" ;
    read -p "Presione ENTER para continuar" answer ;
    echo "";

    ssh -i ${VPS_ID_RSA_FILENAME} ${VPS_USER}@${VPS_NAME} ;
fi