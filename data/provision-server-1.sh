#!/bin/bash
ROOT_UID=0
SUCCESS=0
E_USEREXISTS=70

# Run as root, of course. (this might not be necessary, because we have to run the script somehow with root anyway)
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi  
#------------------------------------------------ Create ansible user
#------------------------------------------------ Create ansible user
#test, if both argument are there
#if [ $# -eq 2 ]; then
username=ansible
pass=ansible

	# Check if user already exists.
	grep -q "$username" /etc/passwd
	if [ $? -eq $SUCCESS ] 
	then	
	#echo "User $username does already exist."
  	#echo "please chose another username."
	#exit $E_USEREXISTS
	userdel -f -r ansible
	fi  

	# previus install whois package
	# apt get install whois
	useradd -p `mkpasswd "$pass"` -d /home/"$username" -m -g users -s /bin/bash "$username"

	echo "the account is setup"

#else
#        echo  " this programm needs 2 arguments you have given $# "
#        echo  " you have to call the script $0 username and the pass "
#fi


#------------------------------------------------ Generate ssh-keygen 
#------------------------------------------------ Generate ssh-keygen 
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N '' <<< y




exit 0
