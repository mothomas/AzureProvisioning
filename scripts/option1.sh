#!/bin/bash
# this is a bash scriot which will be triggered from main installation script
#for full stack deployment.

#stores input value to Terraform and uses it to create configuration templates

IFS= read -r -p "Enter Azure Region: " location
export location
echo "$location"

read -p "Enter Deployment Prefix: " prefix \n 
export prefix
echo -e $prefix

read -p "UIserver vm password The supplied password must be between 6-72 characters  \
long and must satisfy azure password complexity requirements: " password \n
export password

IFS= read -r -p "Enter ssh key for the vm  /home/"username"/.ssh/id_rsa.pub: " keypath \n
export keypath
echo -e $keypath

#read -p "port, which need to be exposed for the application: " aport \n
#export aport
#echo -e $aport

read -p "postgresdb server name this name should be unique in region: " psqldbname \n
export psqldbname
echo -p $psqldbname

read -p "PSql db password The supplied password must be between 6-72 characters long and \
must satisfy azure password complexity requirements: " psqldbpassword \n
export psqldbpassword

read -p "Enter  a domain name for application should be unique in region: " domainname \n
export domainname

#below line will create conf.toml for container deployment

./scripts/conf.toml.sh  $psqldbname $psqldbpassword > /tmp/conf.toml

#rm -rf terraform.tfstate terraform.tfstate.backup

terraform init 

#sleep 10      

terraform plan -var="prefix=$prefix" -var="location=$location" -var="password=$password" \
 -var="psqldbpassword=$psqldbpassword" -var="psqldbname=$psqldbname" -var="domainname=$domainname"

#echo $prefix n $location


terraform apply -auto-approve -var="prefix=$prefix" -var="location=$location" \
-var="password=$password" -var="psqldbpassword=$psqldbpassword" -var="psqldbname=$psqldbname" \
-var="domainname=$domainname"

#to create ansible inventory file from terraform outputs

serv0=$(terraform output vm0_puplic_ip0)
export serv0
serv1=$(terraform output vm1_puplic_ip1)
export serv1
./scripts/hosts.sh $serv0 $serv1 $keypath > hosts
echo -e $keypath

#ansible playbook run 

ansible-playbook -i hosts deploy_ui_app.yaml --extra-vars "ansible_password=$password" --skip-tags=skip-always



#should display fqdn to access application

link=$(terraform output fqdn_of_load_balancer)
export link

#test cases execution

echo "Executing Tests"

if curl -Is http://$link:3000/ | head -1 | grep -q 'HTTP/1.1 200 OK'; then
   echo " App UI is ready "
else
   echo  "App UI not ready please retry or execute necessary ansible scripts "
fi

echo "Testing DB status"

if curl -Is http://$link:3000/healthcheck/ | head -1 |  grep -q 'HTTP/1.1 200 OK'; then
   echo " DB HealthCheck Success" 
else  
   echo " DB not synchronised try running - ansible-playbook -i hosts deploy_uiapp.yml --tags=update-db"  
   
fi

echo -e "\x1b[31;42m*****************************************************************************************\x1b[m"

echo -e "\x1b[32;40m your server will be available at http://$link:3000 \x1b[m"
