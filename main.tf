# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "~> 3.0"
#     }
#   }
# }


provider "azurerm" {
  features {}
  
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}-data"
  location = var.location
  tags     = var.tags
}

# Data Lake Storage Account (para datos estructurados y no estructurados)
resource "azurerm_storage_account" "datalake" {
  name                     = "st${replace(var.project, "-", "")}${var.environment}dl"
  resource_group_name      = azurerm_resource_group.rg.name
  location                = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true # Habilita el espacio de nombres jerárquico (Data Lake)

  tags = var.tags
}

# Containers para el Data Lake
resource "azurerm_storage_data_lake_gen2_filesystem" "processed" {
  for_each           = toset(["processed", "raw", "curated", "sandbox"])
  name               = each.key
  # name               = "processed"
  storage_account_id = azurerm_storage_account.datalake.id
}