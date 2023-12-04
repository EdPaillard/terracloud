data "azurerm_resource_group" "terracloud" {
  name     = var.resource_group_name
}

data "azurerm_dev_test_lab" "terracloud_dev_test_lab" {
  name                = var.dev_test_lab_name
  resource_group_name = data.azurerm_resource_group.terracloud.name
}

data "azurerm_dev_test_virtual_network" "terracloud_vnet" {
  name                = var.virtual_network
  lab_name            = data.azurerm_dev_test_lab.terracloud_dev_test_lab.name
  resource_group_name = data.azurerm_resource_group.terracloud.name
}

data "azurerm_subnet" "terracloud_subnet" {
  name                                           = var.subnet
  virtual_network_name                           = data.azurerm_dev_test_virtual_network.terracloud_vnet.name
  resource_group_name                            = data.azurerm_resource_group.terracloud.name
}

resource "azurerm_dev_test_linux_virtual_machine" "terracloud_vm" {
  count = 3
  name                   = "${var.name}-vm${count.index}"
  lab_name               = data.azurerm_dev_test_lab.terracloud_dev_test_lab.name
  resource_group_name    = data.azurerm_resource_group.terracloud.name
  location               = data.azurerm_resource_group.terracloud.location
  size                   = "Standard_A4_v2"
  username               = var.username
  ssh_key                = file("~/.ssh/azure/id_rsa.pub")
  lab_virtual_network_id = data.azurerm_dev_test_virtual_network.terracloud_vnet.id
  lab_subnet_name        = data.azurerm_subnet.terracloud_subnet.name
  storage_type           = "Standard"
  notes                  = "TerraCloud VMs"
  allow_claim = false

  gallery_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# resource "azurerm_dev_test_linux_virtual_machine" "terracloud_vm2" {
#   name                   = "${var.name}-vm02"
#   lab_name               = data.azurerm_dev_test_lab.terracloud_dev_test_lab.name
#   resource_group_name    = data.azurerm_resource_group.terracloud.name
#   location               = data.azurerm_resource_group.terracloud.location
#   size                   = "Standard_A4_v2"
#   username               = var.username
#   ssh_key                = file("~/.ssh/azure/id_rsa.pub")
#   lab_virtual_network_id = data.azurerm_dev_test_virtual_network.terracloud_vnet.id
#   lab_subnet_name        = data.azurerm_subnet.terracloud_subnet.name
#   storage_type           = "Standard"
#   notes                  = "TerraCloud VMs"
#   allow_claim = false

#   gallery_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }

# resource "null_resource" "auto_claim" {
#   depends_on = [azurerm_dev_test_linux_virtual_machine.terracloud_vm1, azurerm_dev_test_linux_virtual_machine.terracloud_vm2]
#   triggers = {
#     vm_id = azurerm_dev_test_linux_virtual_machine.terracloud_vm1.id,
#     vm2_id = azurerm_dev_test_linux_virtual_machine.terracloud_vm2.id
#   }
#   provisioner "local-exec" {
#     command = "az lab vm claim -g ${data.azurerm_resource_group.terracloud.name} --lab-name ${data.azurerm_dev_test_lab.terracloud_dev_test_lab.name} --name ${azurerm_dev_test_linux_virtual_machine.terracloud_vm1.name}"
#   }
#   provisioner "local-exec" {
#     command = "az lab vm claim -g ${data.azurerm_resource_group.terracloud.name} --lab-name ${data.azurerm_dev_test_lab.terracloud_dev_test_lab.name} --name ${azurerm_dev_test_linux_virtual_machine.terracloud_vm2.name}"
#   }
# }

# resource "null_resource" "start_vm_if_needed" {
#   depends_on = [azurerm_dev_test_linux_virtual_machine.terracloud_vm1, azurerm_dev_test_linux_virtual_machine.terracloud_vm2]
  # triggers = {
  #   vm_id = azurerm_dev_test_linux_virtual_machine.terracloud_vm1.id,
  #   vm2_id = azurerm_dev_test_linux_virtual_machine.terracloud_vm2.id
  # }
#   provisioner "local-exec" {
#     command = "az lab vm start -g ${data.azurerm_resource_group.terracloud.name} --lab-name ${data.azurerm_dev_test_lab.terracloud_dev_test_lab.name} --name ${azurerm_dev_test_linux_virtual_machine.terracloud_vm1.name} || true; az lab vm start -g ${data.azurerm_resource_group.terracloud.name} --lab-name ${data.azurerm_dev_test_lab.terracloud_dev_test_lab.name} --name ${azurerm_dev_test_linux_virtual_machine.terracloud_vm2.name} || true;"
#   }
# }

# resource "local_file" "write_host_file" {
#   content = "all:\n  hosts:\n    ${azurerm_dev_test_linux_virtual_machine.terracloud_vm1.fqdn}:\n    ${azurerm_dev_test_linux_virtual_machine.terracloud_vm2.fqdn}:"
#   filename = "ansible/inventory/hosts.yml"
# }

# resource "ansible_group" "ansible_configuration" {
#   depends_on = [
#     azurerm_dev_test_linux_virtual_machine.terracloud_vm1,
#     azurerm_dev_test_linux_virtual_machine.terracloud_vm2
#   ]
#   name       = "${var.name}-group"
#   children = [ azurerm_dev_test_linux_virtual_machine.terracloud_vm1.fqdn, azurerm_dev_test_linux_virtual_machine.terracloud_vm2.fqdn ]
#   variables = {
#     ansible_connection= "ssh",
#     ansible_ssh_user = var.username
#   }
# }

# resource "null_resource" "ansible_playbook" {
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ansible/inventory/hosts.yaml ansible/configuration.yml"
#   }
# }