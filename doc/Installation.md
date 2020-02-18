
# Installation

## Prerequisites

1. Linux VM
2. Terraform  0.12
3. Ansible  2.5
4. AZ cli
5. Alid Azure Account


## What you need to do


1 execute ./build-n-deploy.sh from the cloned repo directory

      above sript will initiate  Teraform infra provisioning work flow then ansible to 
      deploy application
      
 conf.toml file will be generated and copied to application servers by script
 There is a fair chance of ansible script not running on both VMs
 in this case a rerun of only ansible script will be enough
  use command
   ansible-playbook deploy_ui_app.yaml --list-tags 
   and use tags to re-run play books if required.
 
 ## Installation process can be done step by step also
  execute following steps from Repo directory I have added multiple option in ,.build-n-deploy.sh
  but only 1 will work, since it is only required for E to E deployment. Rest of the options are subset of one
  
  
      
