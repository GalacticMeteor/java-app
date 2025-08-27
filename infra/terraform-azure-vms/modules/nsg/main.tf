# terraform/modules/nsg/main.tf
# Network Security Group module

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Security Rules
resource "azurerm_network_security_rule" "rules" {
  count = length(var.security_rules)

  name                        = var.security_rules[count.index].name
  priority                    = var.security_rules[count.index].priority
  direction                   = var.security_rules[count.index].direction
  access                      = var.security_rules[count.index].access
  protocol                    = var.security_rules[count.index].protocol
  source_port_range           = var.security_rules[count.index].source_port_range
  destination_port_range      = var.security_rules[count.index].destination_port_range
  source_address_prefix       = var.security_rules[count.index].source_address_prefix
  destination_address_prefix  = var.security_rules[count.index].destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Outputs
output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

output "nsg_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.main.name
}