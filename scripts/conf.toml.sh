#!/bin/sh

psqldbname=$1
psqldbpassword=$2

cat << EOF 
"DbUser" = "psqladminun@$psqldbname"
"DbPassword" = "$psqldbpassword"
"DbName" = "postgres"
"DbPort" = "5432"
"DbHost" = "$psqldbname.postgres.database.azure.com"
"ListenHost" = "172.17.0.2"
"ListenPort" = "3000"
EOF



