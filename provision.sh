#!/bin/bash

serverIp=$1
serverName=$2
pkg_whois=whois
pkg_python=python3-pip
pkg_sshpass=sshpass
pkg_ansible=ansible

ROOT_UID=0
SUCCESS=0
E_USEREXISTS=70

username=ansible
pass=ansible


echo "-----------------------------------------------------[$serverIp][$serverName][INICIO]"

echo "-----------------------------------------------------[$serverIp][$serverName][APT UPDATE]"

sudo apt-get update


 
status_whois="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg_whois" )"
#echo " status_whois : $status_whois"
if [ $status_whois != "installed" ]
then
  echo "-----------------------------------------------------[$serverIp][$serverName][INSATALL WHOIS]"
  sudo apt-get install $pkg_whois
else
  echo "-----------------------------------------------------[$serverIp][$serverName][ WHOIS has been installed previusly]"
fi






status_python="$(dpkg-query -W --showformat='${db:Status-Status}' "python3" )"
#echo " status_python status $status_python"
if [ $status_python != "installed" ]
then
  echo "-----------------------------------------------------[$serverIp][$serverName][INSATALL PYTHON]"
  sudo apt-get install -y $pkg_python
else
  echo "-----------------------------------------------------[$serverIp][$serverName][ PYTHON has been installed previusly]"
fi

if [ "$serverName" = "Server1" ]
then
  echo "-----------------------------------------------------[$serverIp][$serverName][INSATALL ANSIBLE]"

  status_ansible="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg_ansible" )"
  #echo " status_python status $status_python"
  if [ $status_ansible != "installed" ]
  then
    echo "-----------------------------------------------------[$serverIp][$serverName][INSATALL ANSIBLE]"
    sudo apt-get install $pkg_ansible -y
  else
    echo "-----------------------------------------------------[$serverIp][$serverName][ ANSIBLE has been installed previusly]"
  fi

  status_sshpass="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg_sshpass" )"
  #echo " status_sshpass : $status_sshpass"
  if [ $status_sshpass != "installed" ]
  then
    echo "-----------------------------------------------------[$serverIp][$serverName][INSATALL SSHPASS]"
    sudo apt-get install $pkg_sshpass
  else
    echo "-----------------------------------------------------[$serverIp][$serverName][ SSHPASS has been installed previusly]"
  fi

fi





# Run as root, of course. (this might not be necessary, because we have to run the script somehow with root anyway)
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  
#------------------------------------------------ Create ansible user

# Check if user already exists.
grep -q "$username" /etc/passwd
if [ $? -eq $SUCCESS ] 
then	
  # userdel -f -r ansible
  echo "-----------------------------------------------------[$serverIp][$serverName][ANSIBLE USER ALREADY CREATED]"
else  
  # previus install whois package
  # apt get install whois
  useradd -p `mkpasswd "$pass"` -d /home/"$username" -m -g users -s /bin/bash "$username"
  #echo "the $pass account is setup"
  echo "-----------------------------------------------------[$serverIp][$serverName][ANSIBLE USER account is setup]"
fi

echo "-----------------------------------------------------[$serverIp][$serverName][SET AS SUDOER]"
usermod -a -G sudo ansible

if [ ! -d "/home/ansible/.ssh" ]
then
  mkdir /home/ansible/.ssh
  chown -R ansible:users  /home/ansible/.ssh
  echo "-----------------------------------------------------[$serverIp][$serverName][SSH-KEYGEN]"
  ssh-keygen -t rsa -f /home/ansible/.ssh/id_rsa -N '' <<< y
fi

#sshpass -p 'ansible' ssh-copy-id -i /home/ansible/.ssh/id_rsa ansible@192.168.1.85 -n
#sshpass -p 'ansible' ssh-copy-id -i /home/ansible/.ssh/id_rsa ansible@192.168.1.86 -n

echo "-----------------------------------------------------[$serverIp][$serverName][END]"