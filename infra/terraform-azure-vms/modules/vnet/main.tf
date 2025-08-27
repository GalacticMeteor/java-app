# terraform/modules/vnet/main.tf
# VNet module

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Subnet
resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_prefix
}

# Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.main.id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.main.name
}