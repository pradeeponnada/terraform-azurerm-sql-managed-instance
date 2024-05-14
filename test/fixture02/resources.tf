# /*****************************************
# /*   Naming conventions
# /*****************************************/

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
  prefix  = ["mod", "test"]
  #suffix = random_string.random.value

  unique-include-numbers = false
  unique-length          = 4
}

# module "pe_naming" {
#   source  = "Azure/naming/azurerm"
#   version = "0.4.1"
#   prefix  = ["mod", "test2"]
#   # suffix = random_string.random.value

#   unique-include-numbers = false
#   unique-length          = 4
# }

# /*****************************************
# /*   Resource Group
# /*****************************************/

resource "azurerm_resource_group" "fixture" {
  name     = module.naming.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

# /*****************************************
# /*   Networking for SQLMI
# /*****************************************/
# resource "azurerm_virtual_network" "fixture" {
#   name                = "example-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.fixture.location
#   resource_group_name = azurerm_resource_group.fixture.name
# }

#   resource "azurerm_subnet" "fixture" {
#     name                                          = "database"
#     resource_group_name                           = azurerm_resource_group.fixture.name
#     virtual_network_name                          = azurerm_virtual_network.fixture.name
#     address_prefixes                              = ["10.0.1.0/24"]
#     private_link_service_network_policies_enabled = true

#   delegation {
#     name = "SQLMI-Delegation"
#     service_delegation {
#       name    = "Microsoft.Sql/managedInstances"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
#     }
#   }
# }

# # # Create a network security group
# # resource "azurerm_network_security_group" "example" {
# #   name                = "sql-nsg"
# #   location            = azurerm_resource_group.fixture.location
# #   resource_group_name = azurerm_resource_group.fixture.name
# # }

# # # Associate NSG with subnet
# # resource "azurerm_subnet_network_security_group_association" "example" {
# #   subnet_id                 = azurerm_subnet.fixture.id
# #   network_security_group_id = azurerm_network_security_group.example.id
# # }


resource "azurerm_network_security_group" "nsg" {
  location            = var.location
  name                = "database-subnet-nsg"
  resource_group_name = module.spoke_vnet.RG_name

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "1443"
    direction                  = "Inbound"
    name                       = "Allow-SQL"
    priority                   = 300
    protocol                   = "Tcp"
    source_address_prefix      = "10.0.0.0/16"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    direction                  = "Inbound"
    name                       = "Allow-HTTPS"
    priority                   = 400
    protocol                   = "Tcp"
    source_address_prefix      = "10.0.0.0/16"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "Allow-ICMP-Inbound"
    priority                   = 4000
    protocol                   = "Icmp"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Deny"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    protocol                   = "Icmp"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = module.spoke_vnet.vnet_details.subnet_ids[0]
}


resource "azurerm_route_table" "fixture" {
  name                          = "test-rt"
  location                      = var.location
  resource_group_name           = module.spoke_vnet.RG_name
  disable_bgp_route_propagation = false
  depends_on = [
    azurerm_subnet.fixture,
  ]
  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "fixture" {
  subnet_id      = module.spoke_vnet.vnet_details.subnet_ids[0]
  route_table_id = azurerm_route_table.fixture.id
}

data "azurerm_client_config" "current" {}

# /*****************************************
# /*   KeyVault for SQLMI
# /*****************************************/

resource "azurerm_key_vault" "kv" {
  name     = module.naming.key_vault.name_unique
  location = azurerm_resource_group.fixture.location
  #resource_group_name         = module.spoke_vnet.RG_name
  resource_group_name         = azurerm_resource_group.fixture.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
      "Purge"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

# # resource "azurerm_private_dns_zone" "fixture" {
# #   name                = "privatelink.vaultcore.azure.net"
# #   resource_group_name = azurerm_resource_group.fixture.name
# # }


# terraform {
#   #source = "git::https://github.com/longviewsystems/tfc-azurerm-ngo-common-spoke.git?ref=1.1.0"
#   #source = "git::https://github.com/longviewsystems/tfc-azurerm-ngo-common-spoke.git?ref=fix/sn-delegation"

#   source = "git::https://github.com/longviewsystems/tfc-azurerm-ngo-common-spoke.git?ref=1.1.1-beta"

# }


# include "root" {
#   path   = find_in_parent_folders("root.hcl")
#   expose = true
# }

# # ---------------------------------------------------------------------------------------------------------------------
# # Override parameters for this environment
# # ---------------------------------------------------------------------------------------------------------------------

# # For vNet, specify the values for the variables that are specific to this environment.
# inputs = {
#   #The location where the resources will be created
#   location              = "westus2"
#   spoke_subscription_id = "fb198e6d-90a8-49f2-9890-59d39b1cc870" #sub-npgen-01

#   # From the common_solution.hcl file
#   # hub_network_peer = {
#   #   name                = "vnet-net-hub-wus2-01"
#   #   resource_group_name = "rg-net-hub-wus2-01"
#   #   subscription_id     = "42084d9a-a002-4b7d-b207-cde2609ee0e0"
#   # }

#   vnet_address_space_with_cidr = "10.80.44.0/24"

#   resource_naming = {
#     environment = "npgen"
#     appname     = "net"
#     instances   = ["01"]
#   }

#   list_of_dns_server_ips = ["10.80.0.4"]

#   firewall_ip = "10.80.0.4"

#   subnets = {
#     # tflint-ignore: terraform_naming_convention
#     servers = {
#       subnet_address_prefix                          = ["10.80.44.0/26"]
#       create_nsg                                     = true
#       service_endpoints                              = []
#       enforce_private_link_endpoint_network_policies = true
#       nsg_inbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.  

#         # Inbound Member from Bastion
#         ["Allow-RDP", 300, "Inbound", "Allow", "Tcp", "3389", "10.0.0.0/8", "*"],
#         ["Allow-HTTPS", 400, "Inbound", "Allow", "Tcp", "443", "10.94.236.0/23", "*"], #For Key Vault access from AzDO Agents      

#         # Allow RDP from NPKCS support subnet 10.80.46.192/26
#         ["Allow-RDP-Inbound-NPKCS", 350, "Inbound", "Allow", "Tcp", "3389", "10.80.46.192/26", "*"], #Allow RDP from npkcs support subnet 10.80.46.192/26

#         #Standard rules
#         ["Allow_All_Local_Subnet_Access", "3000", "Inbound", "Allow", "*", "*", "10.80.44.0/26", "10.80.44.0/26"],
#         ["Allow-ICMP-Inbound", "4000", "Inbound", "Allow", "Icmp", "*", "*", "*"],
#         ["Deny-All-Inbound", "4096", "Inbound", "Deny", "*", "*", "*", "*"]
#       ]

#       nsg_outbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.
#         ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
#       ]
#     }
#     pes = {
#       subnet_name           = "pes"
#       subnet_address_prefix = ["10.80.44.64/26"]
#       create_nsg            = true
#       create_flow_logs      = false
#       //nsg_name                                       = "nsg-analytics-${local.builtin_azure_geo_codes[var.location]}-01"
#       service_endpoints                              = []
#       enforce_private_link_endpoint_network_policies = true
#       add_route                                      = true
#       //route_table_id                                 = module.routes.route_ids[0]

#       nsg_inbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.

#         # Inbound Member to Domain Controller:
#         ["Allow-RDP", 300, "Inbound", "Allow", "Tcp", "3389", "10.0.0.0/8", "*"],
#         ["Allow-HTTPS", 400, "Inbound", "Allow", "Tcp", "443", "*", "*"], # Enable https traffic from any

#         #Standard rules
#         ["Allow_All_Local_Subnet_Access", "3000", "Inbound", "Allow", "*", "*", "10.80.44.64/26", "10.80.44.64/26"],
#         ["Allow-ICMP-Inbound", "4000", "Inbound", "Allow", "Icmp", "*", "*", "*"],
#         ["Deny-All-Inbound", "4096", "Inbound", "Deny", "*", "*", "*", "*"]
#       ]

#       nsg_outbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.
#         ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
#       ]
#     }
#     sqlmi = {
#       subnet_name           = "sqlmi"
#       subnet_address_prefix = ["10.80.44.128/26"]
#       create_nsg            = true
#       create_flow_logs      = false
#       //nsg_name                                       = "nsg-analytics-${local.builtin_azure_geo_codes[var.location]}-01"
#       service_endpoints                              = []
#       service_delegation = {
#         name = "Microsoft.Sql/managedInstances"
#         service_delegation = {
#           name    = "Microsoft.Sql/managedInstances"
#           actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
#         }
#       }      
#       enforce_private_link_endpoint_network_policies = true
#       add_route                                      = true
#       //route_table_id                                 = module.routes.route_ids[0]

#       nsg_inbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.

#         # Inbound Member to Domain Controller:
#         ["Allow-RDP", 300, "Inbound", "Allow", "Tcp", "3389", "10.0.0.0/8", "*"],
#         ["Allow-HTTPS", 400, "Inbound", "Allow", "Tcp", "443", "*", "*"], # Enable https traffic from any
#         ["Allow-SQL", 500, "Inbound", "Allow", "Tcp", "1443", "*", "*"], # Enable https traffic from any source

#         #Standard rules
#         ["Allow_All_Local_Subnet_Access", "3000", "Inbound", "Allow", "*", "*", "10.80.44.64/26", "10.80.44.64/26"],
#         ["Allow-ICMP-Inbound", "4000", "Inbound", "Allow", "Icmp", "*", "*", "*"],
#         ["Deny-All-Inbound", "4096", "Inbound", "Deny", "*", "*", "*", "*"]
#       ]

#       nsg_outbound_rules = [
#         # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
#         # To use defaults, use "" without adding any values.
#         ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
#       ]
#     }    
#   }

#   #Tags for management resources
#   tags = {
#     Details     = "Resources for hosting for smaller application pre-production.",
#     Owner       = "tom_gilmore@tcenergy.com",
#     Criticality = "Medium",
#     Environment = "NonProduction",
#     CostCenter  = "N/A",
#     managedBy   = "terraform(lic-foundations)",
#     Application = "Azure Non Prod Gen",
#   }
# }