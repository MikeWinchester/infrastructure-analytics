variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy"
  default     = "Central US"
}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = "ecommerce"
}

variable "environment" {
  type        = string
  description = "The environment to deploy"
  default     = "dev"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags"
  default = {
    "environment" = "development"
    "date"       = "july-2025"
    "createdby"  = "terraform"
  }
}

variable "sql_admin_username" {
  type        = string
  description = "Username for SQL Server administrator"
  default     = "sqladmin"
}

variable "sql_admin_password" {
  type        = string
  description = "Password for SQL Server administrator"
  sensitive   = true
}

variable "backup_retention_days" {
  type        = number
  description = "Retention period for backups in days"
  default     = 30
}

variable "synapse_sql_admin_username" {
  type        = string
  description = "Username for Synapse SQL administrator"
  default     = "synapseadmin"
}

variable "synapse_sql_admin_password" {
  type        = string
  description = "Password for Synapse SQL administrator"
  sensitive   = true
}