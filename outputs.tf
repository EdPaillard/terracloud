output "lab_name" {
  description = "Dev test lab name"
  value       = var.dev_test_lab_name
}

output "resource_group_name" {
  description = "Resource group name"
  value       = var.resource_group_name
}

output "vm_names" {
  description = "Array of vm names"
  value       = azurerm_dev_test_linux_virtual_machine.terracloud_vm[*].name
}

output "vm_fqdn" {
  description = "Array of vm fqdn"
  value       = azurerm_dev_test_linux_virtual_machine.terracloud_vm[*].fqdn
}