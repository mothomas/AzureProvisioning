#!/bin/sh

serv0=$1
serv1=$2
keypath=$3

cat << EOF
[ui_servers]
$serv0
$serv1
[all:vars]
keypath=$keypath
ansible_connection=ssh
ansible_user=adminuiuser
#ansible_ssh_pass=Nokia@129321
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF