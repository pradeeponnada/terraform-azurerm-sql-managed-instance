

resource "azurerm_mssql_managed_instance" "sqlmi" {
  name                = var.sqlmi_name
  resource_group_name = var.resource_group_name
  location            = var.location
  license_type        = var.license_type
  sku_name            = var.sku_name
  storage_size_in_gb  = var.storage_size_in_gb
  #subnet_id                    = data.azurerm_subnet.subnet.id
  subnet_id                    = var.subnet_id
  vcores                       = var.vcores
  administrator_login          = var.admin_username
  administrator_login_password = random_password.admin_password[0].result
  minimum_tls_version          = var.minimum_tls_version
  proxy_override               = var.proxy_override
  public_data_endpoint_enabled = var.public_data_endpoint_enabled
  storage_account_type         = var.storage_account_type
  #zone_redundant_enabled       = var.zone_redundant_enabled
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

# resource "azurerm_private_endpoint" "sa" {
#   count               = var.create_private_endpoint ? 1 : 0
#   name                = "${var.kv_name}-kv-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_endpoint_subnet_id

#   private_dns_zone_group {
#     name                 = var.private_dns_zone_group_name
#     private_dns_zone_ids = var.kv_private_dns_zone_ids
#   }

#   private_service_connection {
#     name                           = "${var.kv_name}-kv-pe"
#     private_connection_resource_id = azurerm_key_vault.kv.id
#     is_manual_connection           = false
#     subresource_names              = ["vault"]
#   }

#   tags = var.tags

# }