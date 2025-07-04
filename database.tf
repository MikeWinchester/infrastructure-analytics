# SQL Server para datos transaccionales
resource "azurerm_mssql_server" "sql" {
  name                         = "sql-${var.project}-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                    = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  tags = var.tags
}

# Base de datos transaccional
resource "azurerm_mssql_database" "transactional" {
  name           = "${var.project}-${var.environment}-db"
  server_id      = azurerm_mssql_server.sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "S0"
  zone_redundant = false

  threat_detection_policy {
    state = "Enabled"
  }

  tags = var.tags
}

# Redis Cache para caché
resource "azurerm_redis_cache" "redis" {
  name                = "redis-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }

  tags = var.tags
}