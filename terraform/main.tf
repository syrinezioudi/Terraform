provider "azurerm" {
  features {}
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "my-vm" {
  source              = "./modules/my-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.vm_admin_username
  admin_ssh_key       = var.admin_ssh_key
  public_ip           = var.public_ip
  network_subnet_id   = module.networking.subnet_id
}