#!/bin/bash
BORDER="------------------------------------------------------------------------"
clear
echo -e "\n$BORDER"
echo  "This script will provision azure resources and deploy The UI app"
echo  "Before proceeding Make sure you have following applications installed"
echo             *Terraform*
echo             *Ansible*
echo  "Please Choose the option to choose your deployment stages"
echo  " 1. Complete Deployment az_infra + app"
echo  " 2. Deploy Platform"
echo  " 3. Deploy app on already provisioned az_infra"
echo  " 4. Destroy Existing Setup"
echo  " 5. Update App New Version"
echo I have Enabled only option 1 now, other option will be subset of option 1 and can be reused
echo  $BORDER
read -p " Please Enter Your Option: " input
if [ "$input" -eq "$input" 2> /dev/null ]; then
       if [ $input -lt 1 -o $input -gt 5 ]; then
               echo -e " *** YOU HAVE ONLY 5 OPTIONS " 
       elif [ $input -eq 1 ]; then
       
                ./scripts/option1.sh

       elif [ $input -eq 2 ]; then
	       echo -e "\n 2 \n "
       fi	   
else 
   echo "ENDING not a number"
fi
