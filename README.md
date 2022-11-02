# ssh-port-forward
This script is use to port forwarding on remote server

How to use
1. git clone https://github.com/ananddhobi/ssh-port-forward.git
2. cd ssh-port-forward
3. chmod +x portforward.sh
4. ./portforward.sh



note:- in script COUNT=3  --> total no. of ports you want to forward from loacl machine to remote server,change no. according to your use. 


Check all open ports (opened by script)
ps -aux|grep "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep | awk {'print $2'}

Kill/Close all ports opened by script
kill -9 `ps -aux|grep "ssh -o StrictHostKeyChecking=no -f -N -R" | grep -v grep | awk {'print $2'}`
