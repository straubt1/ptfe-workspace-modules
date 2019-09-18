variable "name" {}
variable "location" {}
variable "username" {}
variable "password" {}

variable "vnet_address_spacing" {
  type = "list"
}

variable "subnet_address_prefixes" {
  type = "list"
}

module "networking" {
  source  = "cmm-training.digitalinnovation.dev/tfe-trainer/networking/azurerm"
  version = "0.12.0"

  name                    = var.name
  location                = var.location
  vnet_address_spacing    = var.vnet_address_spacing
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "webserver" {
  source  = "cmm-training.digitalinnovation.dev/tfe-trainer/webserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[0]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

module "appserver" {
  source  = "cmm-training.digitalinnovation.dev/tfe-trainer/appserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[1]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

module "dataserver" {
  source  = "cmm-training.digitalinnovation.dev/tfe-trainer/dataserver/azurerm"
  version = "0.12.0"

  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[2]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

output "networking_info" {
  value = {
    vnet_ids   = module.networking.virtualnetwork-ids
    subnet_ids = module.networking.subnet-ids
  }
}

output "webserver_info" {
  value = {
    vm_ids = module.webserver.vm-ids
    vm_ips = module.webserver.private-ips
  }
}

output "appserver_info" {
  value = {
    vm_ids = module.appserver.vm-ids
    vm_ips = module.appserver.private-ips
  }
}

output "dataserver_info" {
  value = {
    vm_ids = module.dataserver.vm-ids
    vm_ips = module.dataserver.private-ips
  }
}
