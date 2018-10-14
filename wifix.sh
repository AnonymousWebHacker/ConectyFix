#!/bin/bash
# wifix
# Versión: 1.1
# Licencia: GPLv3
# Copyright 2018, AnonymousWebHacker
# for internal use only

# Valor de colores de baner
export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'
export SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Baner del programa
function print_banner() {
	reset # reset terminal
	echo -e "$BLUE
   ||============================||
   ||$RED            WIFIX $BLUE          ||
   ||    By AnonmousWebHacker    ||
   ||----------------------------|| $BLUE
   ||       wifix.sh  v 1.1      ||
   ||============================||	                                             
       $GREEN Create Wifix GNU/Linux #$RESETCOLOR        
	" >&2
}

# Comprobar existencia de adaptadores de red. Wifi/Ethernet
function network_interfaces(){
    #wireless_interface=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`;
    wireless_interface=$(ls /sys/class/net | grep w);
    ethernet_interface=$(ls /sys/class/net | grep e);
    clear;
}


# Menu principal
function menu(){
    centralize;
    title="====================== [ WIFI AP MENU ] ======================"
    prompt="Selection :"
    # Si existe el adaptador wifi
#    if [ wireless_interface= ls /sys/class/net | grep w ] && [ ethernet_interface= ls /sys/class/net | grep e ]; then
        options=("[] Create_AP" "[] Share_Ethernet" "[] More")   
    echo "$title"
    PS3="$prompt"
    select opt in "${options[@]}" "[] Quit/Cancel"; do
        case "$REPLY" in
            1 ) clear; 
                #AP;
                print;;
            2 ) clear;
                Share_Ethernet;;
            3 ) echo "Menu en desarrollo";;

            $(( ${#options[@]}+1 )) ) clear; echo "Tnks by AnonymousWebHacker"; exit;;
            *) echo "Invalid option. Try another one.";continue;;
         esac
     done
     return
}
# Menu Configuracion AP Wifi
function Share_Wifi(){
    #print_banner
    title="=========== [ SHARE WIFI ] ==========="
    prompt="Select:"
    options=("[] Default" "[] Channger SSID/Pass" "[] Back to Menu")
    echo "$title"
    PS3="$prompt"
    select opt in "${options[@]}" "[] Quit/Cancel"; do
        case "$REPLY" in
            1 ) echo "You picked $opt which is option $REPLY";
                WifiDefault;;
            2 ) echo "You picked $opt which is option $REPLY";
                clear;
                ChanngerConfig;;
            3 ) echo "You picked $opt which is option $REPLY";
                clear;
                menu;;
            4 ) echo "You picked $opt which is option $REPLY";
                clear;
                echo "By AnonmousWebHacker";
                exit;;
            $(( ${#options[@]}+1 )) ) clear; echo "AnonymousWebHacker"; exit;;
            *) echo "Invalid option. Try another one.";continue;;
         esac
     done
     return
}
#  Menu  despues de AP Wifi Creada 
function wifiUp(){
    #print_banner
    title="======= [ WIFI AP MENU ] ======="
    prompt="Selection :"
    options=("[] Stop_Share_Wifi" "[] Changer SSID\Pass" "[] More")
    echo "$title"
    PS3="$prompt"
    select opt in "${options[@]}" "[] Quit/Cancel"; do
        case "$REPLY" in
            1 ) echo "You picked $opt which is option $REPLY";
                clear; 
                echo ifconfig ap1 stop;
                menu;
                clear;;
            2 ) echo "You picked $opt which is option $REPLY"; #cambiar este
                clear;
                ChanngerConfig;;
            3 ) echo "You picked $opt which is option $REPLY"; #revisar
                clear; 
                echo ifconfig ap1 stop;
                menu;
                clear;;
            $(( ${#options[@]}+1 )) ) clear; echo "AnonymousWebHacker"; exit;;
            *) echo "Invalid option. Try another one.";continue;;
         esac
     done
     return
}
# Menu Configuracion AP Share_Ethernet
function Share_Ethernet(){
    #print_banner
    title="=========== [ SHARE ETHERNET ] ==========="
    prompt="Select:"
    options=("[] Default" "[] Channger SSID/Pass" "[] Back to Menu")
    echo "$title"
    PS3="$prompt"
    select opt in "${options[@]}" "[] Quit/Cancel"; do
        case "$REPLY" in
            1 ) echo "You picked $opt which is option $REPLY";
                WifiDefault;;
            2 ) echo "You picked $opt which is option $REPLY";
                ChanngerConfig;;
            3 ) echo "You picked $opt which is option $REPLY";
                clear;
                menu;;
            4 ) echo "You picked $opt which is option $REPLY";;
            #    exit;;
            $(( ${#options[@]}+1 )) ) clear; echo "AnonymousWebHacker"; exit;;
            *) echo "Invalid option. Try another one.";continue;;
         esac

     done
     return
}
function ChanngerConfig(){
    clear;
    #print_banner
    echo " [** Introduzca el nombre del SSID **] "
    echo -n "SSID : "
    read SSID
    clear
    echo $SSID > //tmp/wifix.look;
    confirpass;

#    if [ ${#string} -ge 8 ]; then 
#        echo ">= 12 characters. too long"
#        exit
#    else 
#        echo "under 12 characters, not too long."
#    fi
}

function WifiDefault(){
    #print_banner
        SSID="wifi";
        PASS=123456789;
        clear;
       sudo create_ap $wireless_interface $ethernet_interface $SSID $PASS;
            if [ $? -eq 0 ]; then
            echo "AP Creado correctamente";
            echo "[ SSID:  ]  $SSID"
            echo "[Password]: $PASS"
            wifiUp;
            else
            echo "A ocurrido un error, revise los logs en //tmp/wifix.log "
            # Guardar logs
            sudo create_ap $wireless_interface $ethernet_interface $SSID $PASS > //tmp/wifix.logs;
            fi
}
# Validar Caracteristicas Password
function confirpass(){
    #print_banner
    echo " [** Establezca el password del SSID **] "
    echo -n "Password : "
    read PASS 
    let longpass=$(echo ${#PASS});
    
    if [ "$PASS" = '' ]; then
        #echo "Su pass no Cumple con las condiciones";
        clear;
        echo "**********[ El campo pass no pude estar vacio ] **********";
        confirpass;
    fi
        
        # menor de 8 y mayor q 63
    if [[ $longpass -lt 8 ]]; then
        clear;
        echo "***[ Su password debe de tener de 8-63 caracteres ] ***";
        confirpass;
    elif [[ $longpass -gt 63 ]]; then
        echo "***[ Su password debe de tener de 8-63 caracteres ] ***";
        confirpass;
    fi
    clear;
    echo $PASS >> //tmp/wifix.look;
    if [ $noAP = "true" ];
    then
    ap_without_Internet_sharing;
    fi
    sudo create_ap $wireless_interface $wireless_interface $SSID $PASS;
    echo "AP Creado [SSID: $SSID] [Password: $PASS]";
    wifiUp;
}
function Open_Wifi(){
    clear;
    #print_banner
    echo " [** Introduzca el nombre del SSID **] "
    echo -n "SSID : "
    read SSID
    clear
    echo $SSID > //tmp/wifix.look;
    sudo create_ap $wireless_interface $ethernet_interface $SSID;
    wifiUp;
}
function  ap_without_Internet_sharing(){
    noAP="true";
    ChanngerConfig;
    clear;
    echo create_ap -n $wireless_interface MyAccessPoint MyPassPhrase
}
function AP(){
    #print_banner
    title="=========== [ ACCESS POINT ] ==========="
    prompt="Select:"
    options=("[] AP_Open" "[] AP_No_Sharing" "[] Back to Menu")
    echo "$title"
    PS3="$prompt"
    select opt in "${options[@]}" "[] Quit/Cancel"; do
        case "$REPLY" in
            1 ) echo "You picked $opt which is option $REPLY";
                Open_Wifi;;
            2 ) echo "You picked $opt which is option $REPLY";
                ap_without_Internet_sharing;;
            3 ) echo "You picked $opt which is option $REPLY";
                clear;
                menu;;
            $(( ${#options[@]}+1 )) ) clear; echo "AnonymousWebHacker"; exit;;
            *) echo "Invalid option. Try another one.";continue;;
         esac

     done
     return
}
get_root_access()
{
	if [ $USER != "root"  ]; then
        clear;
	    i=8; centralize;
	    echo "                       ...You need root privileges...."
	    sudo -s ./ap-configuration-script 
	else
   	    verify_ap_support;
	    initializations;
	    init_program; 
	fi
}
centralize()
{
	while [ $i -ne 0 ]; do
	  echo " ";
	  ((i-=1));		  		  
	done
}


# Comienzo del script
get_root_access;
network_interfaces
print_banner
menu
