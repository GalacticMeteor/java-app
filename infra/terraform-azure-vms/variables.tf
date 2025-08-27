# terraform/variables.tf
# Root variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-multiregion-devops"
}

variable "primary_location" {
  description = "Primary location for the resource group (metadata only)"
  type        = string
  default     = "North Europe"
}

variable "region_a_location" {
  description = "Location for Region A (Jenkins + Docker)"
  type        = string
  default     = "North Europe"
}

variable "region_b_location" {
  description = "Location for Region B (Kubernetes)"
  type        = string
  default     = "West Europe"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 12
    error_message = "Password must be at least 12 characters long."
  }
}