#!/bin/bash
BORDER="------------------------------------------------------------------------"
clear
echo -e "\n$BORDER"
echo  "This script will provision azure resources and deploy The UI app\n"
echo  "Before proceeding Make sure you have following applications installed\n"
echo             *Terraform*
echo             *Ansible*
echo  "Please Choose the option to choose your deployment stages"
echo  " 1. Complete Deployment az_infra + app"
echo  " 2. Deploy Platform"
echo  " 3. Deploy app on already provisioned az_infra"
echo  " 4. Destroy Existing Setup"
echo  " 5. Update App New Version"
echo  $BORDER
read -p " Please Enter Your Option: " input
if [ "$input" -eq "$input" 2> /dev/null ]; then
       if [ $input -lt 1 -o $input -gt 5 ]; then
               echo -e " *** YOU HAVE ONLY 5 OPTIONS " 
       elif [ $input -eq 1 ]; then
               IFS= read -r -p "Enter Azure Region: " location
                echo $location
                echo "$location"
               read -p "Enter Deployment Prefix: " prefix \n 
                echo -e $prefix
               read -p "Enter SSh key for VMs: " sshkey \n
                echo -e $sshkey
                ./scripts/option1.sh
               
       elif [ $input -eq 2 ]; then
	       echo -e "\n 2 \n "
       fi	   
else 
   ENDING not a number
fi
