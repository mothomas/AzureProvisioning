#!/bin/bash
IFS= read -r -p "Enter Azure Region: " location
export location
echo "$location"
read -p "Enter Deployment Prefix: " prefix \n 
export prefix
echo -e $prefix
read -p "UIserver vm password The supplied password must be between 6-72 characters  \
long and must satisfy azure password complexity requirements: " password \n
export password
IFS= read -r -p "Enter ssh key for the vm: " keypath \n
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
./scripts/conf.toml.sh  $psqldbname $psqldbpassword > /tmp/conf.toml
#rm -rf terraform.tfstate terraform.tfstate.backup
#terraform init 
sleep 10       # change this to more time if initializing for first time
#terraform plan -var="prefix=$prefix" -var="location=$location" -var="password=$password" -var="psqldbpassword=$psqldbpassword" -var="psqldbname=$psqldbname"
#echo $prefix n $location
#terraform apply -auto-approve -var="prefix=$prefix" -var="location=$location" -var="password=$password" -var="psqldbpassword=$psqldbpassword" -var="psqldbname=$psqldbname"

serv0=$(terraform output vm0_puplic_ip0)
export serv0
serv1=$(terraform output vm1_puplic_ip1)
export serv1
./scripts/hosts.sh $serv0 $serv1 $keypath > hosts
echo -e $keypath
ansible-playbook -i hosts deploy_ui_app.yaml --extra-vars "ansible_password=$password" --tags secure_server



