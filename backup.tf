# Backup policies para SQL Database
resource "azurerm_mssql_database_extended_auditing_policy" "db_audit" {
  database_id            = azurerm_mssql_database.transactional.id
  storage_endpoint       = azurerm_storage_account.datalake.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.datalake.primary_access_key
  retention_in_days      = var.backup_retention_days
}

# Azure Backup Vault
resource "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = "backup-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  tags = var.tags
}

# Backup policy para el Data Lake
resource "azurerm_data_protection_backup_policy_blob_storage" "datalake_backup" {
  name               = "backup-policy-datalake"
  vault_id           = azurerm_data_protection_backup_vault.backup_vault.id
  # retention_duration = "P30D" # 30 días de retención
  operational_default_retention_duration = "P30D"
}