# data "azurerm_key_vault" "kv" {
#   count               = var.store_admin_password_in_kv == true ? 1 : 0
#   name                = var.kv_name
#   resource_group_name = var.key_vault_rg_name
# }

resource "random_password" "admin_password" {
  count            = var.generate_admin_password == true ? 1 : 0
  length           = 22
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
  special          = true
}

#store the initial password in the secrets key vault
#Requires that the deployment user has key vault secrets write access
resource "azurerm_key_vault_secret" "admin_password" {
  count = var.store_admin_password_in_kv == true ? 1 : 0
  #key_vault_id = data.azurerm_key_vault.kv[0].id
  key_vault_id = var.key_vault_id
  name         = "${var.sqlmi_name}-${var.admin_username}-password"
  value        = random_password.admin_password[0].result
  tags         = var.tags
}
