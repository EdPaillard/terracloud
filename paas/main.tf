terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# provider "github" {
#   token = "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"
# }

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

data "azurerm_resource_group" "paas" {
  name     = var.resource_group_name
}

resource "azurerm_service_plan" "appserviceplan" {
  name                = "CloudPaas-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.paas.location
  resource_group_name = data.azurerm_resource_group.paas.name
  os_type             = "Linux"
  sku_name            = "B1"
}

#Surement modifier cette partie afin de mettre un truc dans la webApp
resource "azurerm_linux_web_app" "webappcontapp" {
  name                = "webapp-${random_integer.ri.result}"
  location            = data.azurerm_resource_group.paas.location
  resource_group_name = data.azurerm_resource_group.paas.name
  service_plan_id = resource.azurerm_service_plan.appserviceplan.id
  https_only            = true  
  site_config {
    always_on                = "true"
    #app_command_line = "cp /home/site/wwwroot/default /etc/nginx/sites-available/default && service nginx reload"
    application_stack {
      php_version = "7.4"
    }
  }
  app_settings = {
    #DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io",
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false",
    DB_CONNECTION="mysql",
    DB_HOST="terracloud-mysqlserver.mysql.database.azure.com",
    DB_PORT=3306,
    DB_DATABASE="terracloud-database",
    DB_USERNAME="mysqladminun",
    DB_PASSWORD="H@Sh1CoR3!",
    MYSQL_ATTR_SSL_CA="/home/site/wwwroot/ssl/DigiCertGlobalRootCA.crt.pem",
    LOG_CHANNEL="stderr",
    APP_DEBUG=true,
    APP_KEY="base64:Dsz40HWwbCqnq0oxMsjq7fItmKIeBfCBGORfspaI1Kw="
  }
  
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id                 = azurerm_linux_web_app.webappcontapp.id
  repo_url               = "https://github.com/EdPaillard/terracloud.git"
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mysql_server" "terracloud_mysql" {
  name                = "terracloud-mysqlserver"
  location            = data.azurerm_resource_group.paas.location
  resource_group_name = data.azurerm_resource_group.paas.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_2"
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "terracloud_database" {
  name                = "terracloud-database"
  resource_group_name = data.azurerm_resource_group.paas.name
  server_name         = azurerm_mysql_server.terracloud_mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

output "app_url" {
  value = azurerm_linux_web_app.webappcontapp.default_hostname
}