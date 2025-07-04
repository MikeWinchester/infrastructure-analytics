# Synapse Analytics Workspace
resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "synapse-${var.project}-${var.environment}"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                            = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.containers["curated"].id
  sql_administrator_login              = var.synapse_sql_admin_username
  sql_administrator_login_password     = var.synapse_sql_admin_password

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Power BI Embedded
resource "azurerm_powerbi_embedded" "pbi" {
  name                = "pbi-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "A1"
  administrators      = ["admin@example.com"]

  tags = var.tags
}

# Databricks Workspace (opcional para procesamiento avanzado)
resource "azurerm_databricks_workspace" "databricks" {
  name                = "dbricks-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "premium"

  tags = var.tags
}