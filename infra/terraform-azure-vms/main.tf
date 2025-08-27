# terraform/main.tf
# Root configuration that calls modules

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Single Resource Group for all resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.primary_location

  tags = {
    Environment = var.environment
    Project     = "MultiRegion-DevOps"
  }
}

# Region A - Jenkins + Docker (North Europe)
module "vnet_region_a" {
  source = "./modules/vnet"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_a_location
  vnet_name           = "vnet-region-a"
  address_space       = ["10.1.0.0/16"]
  subnet_name         = "subnet-devops"
  subnet_prefix       = ["10.1.1.0/24"]

  tags = {
    Environment = var.environment
    Region      = "A"
  }
}

module "nsg_region_a" {
  source = "./modules/nsg"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_a_location
  nsg_name            = "nsg-region-a-devops"

  # Security rules for Jenkins + Docker
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Jenkins"
      priority                   = 1004
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Docker"
      priority                   = 1005
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "2376"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  tags = {
    Environment = var.environment
    Region      = "A"
  }
}

# Associate NSG with subnet in Region A
resource "azurerm_subnet_network_security_group_association" "region_a" {
  subnet_id                 = module.vnet_region_a.subnet_id
  network_security_group_id = module.nsg_region_a.nsg_id
}

# Jenkins VM
module "vm_jenkins" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_a_location
  vm_name             = "vm-jenkins"
  vm_size             = "Standard_B2s" # 2 vCPUs, 4GB RAM
  subnet_id           = module.vnet_region_a.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  custom_data = base64encode(templatefile("${path.module}/scripts/jenkins-setup.sh", {}))

  tags = {
    Environment = var.environment
    Region      = "A"
    Role        = "Jenkins"
  }
}

# Docker VM
module "vm_docker" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_a_location
  vm_name             = "vm-docker"
  vm_size             = "Standard_B2s" # 2 vCPUs, 4GB RAM
  subnet_id           = module.vnet_region_a.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  custom_data = base64encode(templatefile("${path.module}/scripts/docker-setup.sh", {}))

  tags = {
    Environment = var.environment
    Region      = "A"
    Role        = "Docker"
  }
}

# Region B - Kubernetes Cluster (West Europe)
module "vnet_region_b" {
  source = "./modules/vnet"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_b_location
  vnet_name           = "vnet-region-b"
  address_space       = ["10.2.0.0/16"]
  subnet_name         = "subnet-kubernetes"
  subnet_prefix       = ["10.2.1.0/24"]

  tags = {
    Environment = var.environment
    Region      = "B"
  }
}

module "nsg_region_b" {
  source = "./modules/nsg"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_b_location
  nsg_name            = "nsg-region-b-k8s"

  # Security rules for Kubernetes
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "KubernetesAPI"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "6443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "KubeletAPI"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "10250"
      source_address_prefix      = "10.2.0.0/16"
      destination_address_prefix = "*"
    },
    {
      name                       = "NodePortServices"
      priority                   = 1004
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "30000-32767"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "FlannelOverlay"
      priority                   = 1005
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "8472"
      source_address_prefix      = "10.2.0.0/16"
      destination_address_prefix = "*"
    }
  ]

  tags = {
    Environment = var.environment
    Region      = "B"
  }
}

# Associate NSG with subnet in Region B
resource "azurerm_subnet_network_security_group_association" "region_b" {
  subnet_id                 = module.vnet_region_b.subnet_id
  network_security_group_id = module.nsg_region_b.nsg_id
}

# Kubernetes Master VM
module "vm_k8s_master" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_b_location
  vm_name             = "vm-k8s-master"
  vm_size             = "Standard_B2s" # 2 vCPUs, 4GB RAM
  subnet_id           = module.vnet_region_b.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  #custom_data = base64encode(templatefile("${path.module}/scripts/k8s-master-setup.sh", {}))

  tags = {
    Environment = var.environment
    Region      = "B"
    Role        = "K8s-Master"
  }
}

# Kubernetes Worker 1 VM
module "vm_k8s_worker1" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_b_location
  vm_name             = "vm-k8s-worker1"
  vm_size             = "Standard_B1s" # 1 vCPU, 1GB RAM
  subnet_id           = module.vnet_region_b.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  #custom_data = base64encode(templatefile("${path.module}/scripts/k8s-worker-setup.sh", {}))

  tags = {
    Environment = var.environment
    Region      = "B"
    Role        = "K8s-Worker1"
  }
}

# Kubernetes Worker 2 VM
module "vm_k8s_worker2" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.region_b_location
  vm_name             = "vm-k8s-worker2"
  vm_size             = "Standard_B1s" # 1 vCPU, 1GB RAM
  subnet_id           = module.vnet_region_b.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  #custom_data = base64encode(templatefile("${path.module}/scripts/k8s-worker-setup.sh", {}))

  tags = {
    Environment = var.environment
    Region      = "B"
    Role        = "K8s-Worker2"
  }
}