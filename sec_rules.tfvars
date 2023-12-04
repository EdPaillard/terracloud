
nsg_rules = {
  http = {
    name                   = "HTTP"
    priority               = 320
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "80"
  }
  https = {
    name                   = "HTTPS"
    priority               = 340
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "443"
  }
  ssh = {
    name                   = "SSH"
    priority               = 300
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "22"
  }
}


