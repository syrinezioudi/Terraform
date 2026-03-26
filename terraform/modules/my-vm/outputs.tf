output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "resource_group" {
  value = azurerm_linux_virtual_machine.vm.resource_group_name
}

output "public_ip" {
  value = var.public_ip ? azurerm_public_ip.pip[0].ip_address : null
}