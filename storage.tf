# Blob Storage para multimedia (imágenes, videos)
resource "azurerm_storage_account" "media" {
  name                     = "st${replace(var.project, "-", "")}${var.environment}media"
  resource_group_name      = azurerm_resource_group.rg.name
  location                = var.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"

  # static_website {
  #   index_document = "index.html"
  # }

  tags = var.tags
}

# Containers para el blob storage
resource "azurerm_storage_container" "media_containers" {
  for_each              = toset(["products", "profiles", "marketing"])
  name                  = each.key
  # storage_account_name  = azurerm_storage_account.media.name
  storage_account_id = azurerm_storage_account.media.id
  container_access_type = "private"
}