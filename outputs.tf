output "SQLMI_name" {
  value       = azurerm_mssql_managed_instance.sqlmi.name
  description = "The name of the Azure SQL Managed Instance."
}

output "SQLMI_id" {
  value       = azurerm_mssql_managed_instance.sqlmi.id
  description = "The resource id of the Azure SQL Managed Instance."
}

