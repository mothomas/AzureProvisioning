variable "prefix" {
  description = "The prefix which should be used for all"
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
}

variable "password" {
  description = "The supplied password must be between 6-72 characters long and must satisfy azure password complexity requirements"
}

variable "psqldbpassword" {
  description = "PSql db password The supplied password must be between 6-72 characters long and must satisfy azure password complexity requirements"
}

variable "psqldbname" {
  description = "postgresdb server name this name should be unique in region"
  default = "pstgrestak"
}

#variable "aport" {
#  description = "port, which need to be exposed for the application"
#  default = "3000"
#}


#variable "sshkey" {
#  description = "load a puplic key to vm"
#}


