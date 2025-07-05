# Data Factory para ETL
resource "azurerm_data_factory" "adf" {
  name                = "adf-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Integration Runtime para Data Factory
resource "azurerm_data_factory_integration_runtime_azure" "adf_ir" {
  name            = "adf-ir-${var.project}-${var.environment}"
  data_factory_id = azurerm_data_factory.adf.id
  location        = var.location
}

# Linked Services para Data Factory
resource "azurerm_data_factory_linked_service_azure_blob_storage" "datalake_linked" {
  name              = "datalake_linked"
  data_factory_id   = azurerm_data_factory.adf.id
  connection_string = azurerm_storage_account.datalake.primary_connection_string
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "sql_linked" {
  name              = "sql_linked"
  data_factory_id   = azurerm_data_factory.adf.id
  connection_string = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.transactional.name};User ID=${var.sql_admin_username};Password=${var.sql_admin_password};Trusted_Connection=False;Encrypt=True;"
}

resource "azurerm_data_factory_dataset_azure_sql_table" "sql_table" {
  name                = "azureaqltable1"
  data_factory_id     = azurerm_data_factory.adf.id
  # linked_service_name = azurerm_data_factory_linked_service_azure_sql_database.sql_linked.name
  linked_service_id = azurerm_data_factory_linked_service_azure_sql_database.sql_linked.id
}

resource "azurerm_data_factory_dataset_azure_blob" "blob" {
  name                = "AzureBlob1"
  data_factory_id     = azurerm_data_factory.adf.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.datalake_linked.name
  path                = "processed" # Nombre de tu contenedor
}

# # Pipeline de ejemplo para cargar datos
# resource "azurerm_data_factory_pipeline" "orders_pipeline" {
#   name            = "orders_processing_pipeline"
#   data_factory_id = azurerm_data_factory.adf.id

#   activities_json = <<JSON
# [
#   {
#     "name": "CopyOrdersToDatalake",
#     "type": "Copy",
#     "inputs": [
#       {
#         "referenceName": "azuresqltable1",
#         "type": "DatasetReference"
#       }
#     ],
#     "outputs": [
#       {
#         "referenceName": "AzureBlob1",
#         "type": "DatasetReference"
#       }
#     ],
#     "typeProperties": {
#       "source": {
#         "type": "SqlSource"
#       },
#       "sink": {
#         "type": "BlobSink"
#       }
#     }
#   }
# ]
# JSON
# }