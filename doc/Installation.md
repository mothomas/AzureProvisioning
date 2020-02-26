
# Installation

## Prerequisites

1. Linux VM
2. Terraform  0.12
3. Ansible  2.5
4. AZ cli (azure cli)
5. valid Azure Account


## What you need to do
1 Azure login
  execute 
     az login 
  from your terminal, you will be prompted to authenticate to azure cloud
  (https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest)

2 clone git repo

3 change working directory to cloned repo directory
  execute ./build-n-deploy.sh from the cloned repo directory. Enter the variables as prompted

      above sript will initiate  Teraform infra provisioning work flow then ansible to 
      deploy application
      
 conf.toml file will be generated and copied to application servers by script based on input variable
 (currently port 3000 is hard coded as app port but can be changed to a variable based port.
 
 if ansible rerun required 
  use command
   ansible-playbook deploy_ui_app.yaml --list-tags 
   and use tags to re-run required playbook.
 
 ### Multiple option in deployment script
  I have added multiple option in ,.build-n-deploy.sh
  but only 1 will work, for E to E deployment. Rest of the options are subset of 1. and script can be reused
  
  
  
      
