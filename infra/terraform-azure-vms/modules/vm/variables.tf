# terraform/modules/vm/variables.tf
# VM module variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "custom_data" {
  description = "Custom data script for VM initialization"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}