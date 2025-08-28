# terraform/outputs.tf
# Root outputs

# Resource Group
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Region A - Jenkins + Docker
output "jenkins_public_ip" {
  description = "Public IP address of Jenkins VM"
  value       = module.vm_jenkins_agent.public_ip_address
}

output "jenkins_private_ip" {
  description = "Private IP address of Jenkins VM"
  value       = module.vm_jenkins_agent.private_ip_address
}

output "docker_public_ip" {
  description = "Public IP address of Docker VM"
  value       = module.vm_jenkins_master.public_ip_address
}

output "docker_private_ip" {
  description = "Private IP address of Docker VM"
  value       = module.vm_jenkins_master.private_ip_address
}

output "region_a_vnet_id" {
  description = "ID of Region A VNet"
  value       = module.vnet_region_a.vnet_id
}

# Region B - Kubernetes
output "k8s_master_public_ip" {
  description = "Public IP address of Kubernetes Master VM"
  value       = module.vm_k8s_master.public_ip_address
}

output "k8s_master_private_ip" {
  description = "Private IP address of Kubernetes Master VM"
  value       = module.vm_k8s_master.private_ip_address
}

output "k8s_worker1_public_ip" {
  description = "Public IP address of Kubernetes Worker 1 VM"
  value       = module.vm_k8s_worker1.public_ip_address
}

output "k8s_worker1_private_ip" {
  description = "Private IP address of Kubernetes Worker 1 VM"
  value       = module.vm_k8s_worker1.private_ip_address
}

output "k8s_worker2_public_ip" {
  description = "Public IP address of Kubernetes Worker 2 VM"
  value       = module.vm_k8s_worker2.public_ip_address
}

output "k8s_worker2_private_ip" {
  description = "Private IP address of Kubernetes Worker 2 VM"
  value       = module.vm_k8s_worker2.private_ip_address
}

output "region_b_vnet_id" {
  description = "ID of Region B VNet"
  value       = module.vnet_region_b.vnet_id
}

# Connection Information
output "jenkins_url" {
  description = "Jenkins access URL"
  value       = "http://${module.vm_jenkins_agent.public_ip_address}:8080"
}

output "k8s_api_server" {
  description = "Kubernetes API server URL"
  value       = "https://${module.vm_k8s_master.public_ip_address}:6443"
}

# SSH Commands
output "ssh_commands" {
  description = "SSH commands to connect to VMs"
  value = {
    jenkins     = "ssh ${var.admin_username}@${module.vm_jenkins_agent.public_ip_address}"
    docker      = "ssh ${var.admin_username}@${module.vm_jenkins_master.public_ip_address}"
    k8s_master  = "ssh ${var.admin_username}@${module.vm_k8s_master.public_ip_address}"
    k8s_worker1 = "ssh ${var.admin_username}@${module.vm_k8s_worker1.public_ip_address}"
    k8s_worker2 = "ssh ${var.admin_username}@${module.vm_k8s_worker2.public_ip_address}"
  }
}