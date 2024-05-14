
module "sqlmi_test" {
  source              = "../../"
  sqlmi_name          = module.naming.mssql_managed_instance.name_unique
  resource_group_name = azurerm_resource_group.fixture.name #module.spoke_vnet.RG_name
  #resource_group_name  = "rg-net-npgen-wus2-01"
  location = azurerm_resource_group.fixture.location
  #kv_name  = azurerm_key_vault.kv.name
  #sqlmi_subnet_name       = "sqlmi"
  subnet_id = module.spoke_vnet.vnet_details.subnet_ids[0]
  #vnet_name               = module.spoke_vnet.vnet_details["virtual_network_name"]
  #vnet_name                    = "vnet-net-npgen-wus2-01"
  admin_username             = "sqlmiadmin"
  generate_admin_password    = true
  store_admin_password_in_kv = true
  #key_vault_rg_name       = "rg-net-npgen-wus2-01"
  key_vault_id = azurerm_key_vault.kv.id
  tags         = var.tags
  depends_on   = [module.spoke_vnet, azurerm_key_vault.kv]
}

module "spoke_vnet" {
  source                          = "git::https://github.com/longviewsystems/tfc-azurerm-ngo-common-spoke.git?ref=1.1.2-alpha"
  spoke_subscription_id           = "fdd234dc-7c17-4710-958a-2fc1fb7ba842"
  vnet_address_space_with_cidr    = "10.90.44.0/24"
  location                        = "westus2"  #var.location
  peering_use_remote_dest_gateway = false
  list_of_dns_server_ips          = ["10.90.0.4"]
  firewall_ip                     = "10.90.0.4"
  subnets                         = var.subnets
  resource_naming                 = var.resource_naming
  hub_network_peer                = var.hub_network_peer
  tags                            = var.tags
}


# # Test module with PE
# module "kv_test_with_pe" {
#   source = "../../"

#   resource_group_name = azurerm_resource_group.fixture.name
#   location            = azurerm_resource_group.fixture.location


#   kv_name = module.pe_naming.key_vault.name_unique

#   default_action             = "Deny"
#   ip_rules                   = [local.ip_data.ip] //["108.173.252.52"]//[local.public_ip]
#   virtual_network_subnet_ids = [azurerm_subnet.fixture.id]


#   create_private_endpoint    = true
#   private_endpoint_subnet_id = azurerm_subnet.fixture.id
#   kv_private_dns_zone_ids    = [azurerm_private_dns_zone.fixture.id]

#   tags = var.tags

# }


# TODO: Create an NSG, and link to it to subnet.  We want to see if the NSG associations causes issues where the NGO network module wants to remove the association.
#TODO: Create a Route Table and link it to the subnet.  We want to see if the Route Table associations causes NGO network issues..