#!/bin/bash
###################################################################
#Script Name	:    portforward.sh                                                                                           
#Description	:    forward port from local machine to remote machine                                                                                                                                                                       
#Author       	:    Anand Dhobi                                              
#Creation Date  :    31-10-2022                                      
###################################################################

TOTAL_OPEN_PORT=`ps -aux| grep -i "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep |wc -l`
CURRENT_PORT=`ps -aux|grep "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep | awk {'print $17'} | cut -d ":" -f1`
COUNT=3

check_sshpass_status(){
if [ -e /usr/bin/sshpass ]
then
check_if_port_already_running_on_remote_server
else
echo "sshpass not installed,please install sshpass"
fi
}


check_if_port_already_running_on_local_machine(){
if (( $TOTAL_OPEN_PORT>=$COUNT ))
then
echo -e "$TOTAL_OPEN_PORT port already exposed on remote server from this machine,can not open another.\nExposed port/ports\n$CURRENT_PORT"
exit 0;
else
echo "port $EXPOSE_PORT not running on local machine"
open_port
fi
}

check_if_port_already_running_on_remote_server(){
if (( $TOTAL_OPEN_PORT>=$COUNT ))
then
echo -e "$TOTAL_OPEN_PORT port already exposed on remote server from this machine,can not open another.\nExposed port/ports\n$CURRENT_PORT"
exit 0;
else


	
sshpass -p $PASSWORD ssh $SSHUSER@$HOST "netstat -tulpn | grep $EXPOSE_PORT" > /dev/null 2>&1
if [ $? -eq 0 ]
then
        echo "port $EXPOSE_PORT already running on remote server $HOST , Use another port"
want_to_exit_or_again_open_another_port
else
        echo "port $EXPOSE_PORT not running on remote server"
check_if_port_already_running_on_local_machine
fi


fi
}
 
 
open_port(){
echo "opening port $EXPOSE_PORT"
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no -f -N -R $EXPOSE_PORT:127.0.0.1:22 $SSHUSER@$HOST > /dev/null 2>&1
if [ $? == 0 ]
then
local CURRENT_PORT=`ps -aux |grep "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep | awk {'print $17'} | cut -d ":" -f1`
echo -e "current running port(s)\n$CURRENT_PORT"
local test=`ps -aux |grep "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep | awk {'print $17'} | cut -d ":" -f1 | tac`
echo -e "latest open port(s)\n$test"
local CURRENT_TOTAL=`ps -aux| grep -i "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep |wc -l`

 

if (( $CURRENT_TOTAL>=$COUNT ))
then
exit
fi

if (( $CURRENT_TOTAL>=1 ))
then
for ports in $test
do
if [ $EXPOSE_PORT -eq $ports ]
then
exit

else
open_port
fi
done
else
open_port
fi
else
echo "Provided credientials wrong"
exit
fi
}


want_to_exit_or_again_open_another_port(){
echo "press y/Y to exit,any other key for again or simply press Enter"
read ans
if [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
then
exit
else
user_input
check_if_port_already_running_on_remote_server
fi
}


user_input(){
echo "Enter remote server IP"
read HOST
echo "Enter username"
read SSHUSER
echo "Enter port for expose"
read EXPOSE_PORT
echo "Enter password"
read -s  PASSWORD
}

user_input
check_sshpass_status
