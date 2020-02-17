#!/bin/bash
rm -rf terraform.tfstate terraform.tfstate.backup
terraform init 
terraform plan -var="prefix=$prefix" -var="location=$location" -var="sshkey=$sshkey"
terraform apply -auto-approve -var="prefix=$prefix" -var="location=$location" -var="sshkey=$ssh-key"
