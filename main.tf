#provider "azurerm" {
# Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
#  version = "=1.44.0"
#}  

resource "azurerm_resource_group" "UIserver" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

locals {
  instance_count = 2
}

resource "azurerm_virtual_network" "UIserver" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.UIserver.location
  resource_group_name = azurerm_resource_group.UIserver.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.UIserver.name
  virtual_network_name = azurerm_virtual_network.UIserver.name
  address_prefix       = "10.0.2.0/24"
}


resource "azurerm_public_ip" "piplb" {
  #count               = local.public_ip_count
  name                = "${var.prefix}-piplb"
  resource_group_name = azurerm_resource_group.UIserver.name
  location            = azurerm_resource_group.UIserver.location
  domain_name_label   = "mobthomasservianapp"
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "pip" {
  count               = local.instance_count
  name                = "${var.prefix}-pip${count.index}"
  resource_group_name = azurerm_resource_group.UIserver.name
  location            = azurerm_resource_group.UIserver.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "UIserver" {
  count                      = local.instance_count
  name                       = "${var.prefix}-nic${count.index}"
  resource_group_name        = azurerm_resource_group.UIserver.name
  location                   = azurerm_resource_group.UIserver.location
  network_security_group_id  = azurerm_network_security_group.UIserver.id
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.prefix}avset"
  location                     = azurerm_resource_group.UIserver.location
  resource_group_name          = azurerm_resource_group.UIserver.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_security_group" "UIserver" {
  name                = "appserver"
  location            = azurerm_resource_group.UIserver.location
  resource_group_name = azurerm_resource_group.UIserver.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AAp"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "3000"
    destination_address_prefix = azurerm_subnet.internal.address_prefix
  }
   security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_lb" "UIserver" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.UIserver.location
  resource_group_name = azurerm_resource_group.UIserver.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.piplb.id
  }
}


resource "azurerm_lb_backend_address_pool" "UIserver" {
  resource_group_name = azurerm_resource_group.UIserver.name
  loadbalancer_id     = azurerm_lb.UIserver.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "UIserver" {
  resource_group_name = azurerm_resource_group.UIserver.name
  loadbalancer_id     = azurerm_lb.UIserver.id
  name                = "UIaap_Probe"
  protocol            = "Tcp"
  port                = "3000"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}
resource "azurerm_lb_rule" "UIserver" {
  resource_group_name            = azurerm_resource_group.UIserver.name
  loadbalancer_id                = azurerm_lb.UIserver.id
  name                           = "Aap_Access"
  protocol                       = "Tcp"
  frontend_port                  = 3000
  backend_port                   = 3000
  probe_id                       = azurerm_lb_probe.UIserver.id
  frontend_ip_configuration_name = azurerm_lb.UIserver.frontend_ip_configuration[0].name
}

resource "azurerm_network_interface_backend_address_pool_association" "UIserver" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.UIserver.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.UIserver.*.id, count.index)
}


resource "azurerm_postgresql_server" "UIserver" {
  name                = "postgrestak"
  location            = azurerm_resource_group.UIserver.location
  resource_group_name = azurerm_resource_group.UIserver.name

  sku_name = "B_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "psqladminun"
  administrator_login_password = "Changeme@129321"
  version                      = "9.5"
  ssl_enforcement              = "Disabled"
}
resource "azurerm_postgresql_firewall_rule" "UIserver" {
  name                = "DBsec"
  resource_group_name = azurerm_resource_group.UIserver.name
  server_name         = azurerm_postgresql_server.UIserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

#resource "azurerm_postgresql_database" "UIserver" {
#  name                = "UIserverdb"
#  resource_group_name = azurerm_resource_group.UIserver.name
#  server_name         = azurerm_postgresql_server.UIserver.name
#  charset             = "UTF8"
#  collation           = "English_United States.1252"
#}


# Create virtual machine
resource "azurerm_virtual_machine" "UIserver" {
    count                 = local.instance_count
	  name                  = "${var.prefix}-vm${count.index}"
    location              = azurerm_resource_group.UIserver.location
    resource_group_name   = azurerm_resource_group.UIserver.name
    network_interface_ids = [azurerm_network_interface.UIserver[count.index].id,]
    availability_set_id   = azurerm_availability_set.avset.id
    vm_size               = "Standard_DS1_v2"
    
    storage_os_disk {
        name              = "myOsDisk${count.index}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "uiappserver"
        admin_username = "adminuiuser"
		   # admin_password = "${var.password}"
    }

    os_profile_linux_config {
        disable_password_authentication = true 
        ssh_keys {
            path     = "/home/adminuiuser/.ssh/authorized_keys"
            key_data = "${var.sshkey}"
        }
}
}