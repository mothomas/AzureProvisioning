output "vm0_puplic_ip0" {
  description = "public ip address index0."
  value       = "${azurerm_public_ip.pip[0].ip_address}"
}

output "vm1_puplic_ip1" {
  description = "public ip address index1."
  value       = "${azurerm_public_ip.pip[1].ip_address}"
}


output "fqdn_of_load_balancer" {
  description = "lpad balancers fqdn"
  value       = "${azurerm_public_ip.piplb.fqdn}"
}