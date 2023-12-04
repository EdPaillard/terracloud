variable "nsg_rules" {
  type    = object({})
  default = {}
}

variable "name" {
  type    = string
  default = "TerraCloud"
}

variable "resource_group_name" {
  type    = string
  default = "t-clo-901-lil-2"
}

variable "resource_group_location" {
  type    = string
  default = "westeurope"
}

variable "dev_test_lab_name" {
  type    = string
  default = "t-clo-901-lil-2"
}

variable "virtual_network" {
  type    = string
  default = "t-clo-901-lil-2"
}

variable "subnet" {
  type    = string
  default = "t-clo-901-lil-2Subnet"
}

variable "username" {
  type    = string
  default = "terracloud"
}

variable "password" {
  type    = string
  default = "secretpassword"
}

variable "array" {
  type    = number
  default = 2
}
// Dtl