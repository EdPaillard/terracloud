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
  default = "t-clo-901-lil-2-items"
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
// Dtl

# variable "docker_image" {
#   description = "The Docker image to deploy"
#   default     = "nginx:latest"
# }

# variable "github_auth_token" {
#   type        = string
#   default = "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"
# }