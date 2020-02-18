
# Installation

## Prerequisites

1. Linux VM
2. Terraform  0.12
3. Ansible  2.5
4. AZ cli
5. Alid Azure Account


## What you need to do


1 execute ./build-n-deploy.sh from the cloned repo directory. Enter the variables as prompted

      above sript will initiate  Teraform infra provisioning work flow then ansible to 
      deploy application
      
 conf.toml file will be generated and copied to application servers by script based on input variable
 (currently port 3000 is hard coded as app port but can be changed to a variable based port.
 There is a fair chance of ansible script not running on both VMs, This is a random behaviour.
 in this case a rerun of only ansible script is enough
  use command
   ansible-playbook deploy_ui_app.yaml --list-tags 
   and use tags to re-run play books if required.
 
 ### Multiple option in deployment script
  I have added multiple option in ,.build-n-deploy.sh
  but only 1 will work, for E to E deployment. Rest of the options are subset of 1. and script can be reused
  
  
  
      
