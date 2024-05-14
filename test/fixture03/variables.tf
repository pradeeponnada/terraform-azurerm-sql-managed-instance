variable "location" {
  type        = string
  description = "Location used to deploy the resources"
  default     = "westus2"
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  default = {
    environment = "test"
    managed_by  = "terratest"
  }
}

variable "subnets" {
  type = map(object({
    subnet_address_prefix = list(string)
    create_nsg            = bool
    service_endpoints     = list(string)
    #service_delegation                             = optional(object({ name = string, service_delegation = optional(object({ name = string, actions = list(string) })) }), null)
    service_delegation                             = optional(object({ name = string, service_delegation = object({ name = string, actions = list(string) }) }), null)
    enforce_private_link_endpoint_network_policies = bool
    nsg_inbound_rules                              = list(list(any))
    nsg_outbound_rules                             = list(list(any))
  }))

  description = "Details for each subnet to be created in the spoke.  Reference examples to see how to configure."
  default = {
    # tflint-ignore: terraform_naming_convention
    sqlmi = {
      subnet_name           = "sqlmi"
      subnet_address_prefix = ["10.90.44.128/26"]
      create_nsg            = false  #TODO: Set to false
      create_flow_logs      = false
      //nsg_name                                       = "nsg-analytics-${local.builtin_azure_geo_codes[var.location]}-01"
      service_endpoints = []
      service_delegation = {
        name = "Microsoft.Sql/managedInstances"
        service_delegation = {
          name    = "Microsoft.Sql/managedInstances"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
        }
      }
      enforce_private_link_endpoint_network_policies = true
      add_route                                      = false  #TODO: Set to false
      //route_table_id                                 = module.routes.route_ids[0]

      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.

        # Inbound Member to Domain Controller:
        ["Allow-RDP", 300, "Inbound", "Allow", "Tcp", "3389", "10.0.0.0/8", "*"],
        ["Allow-HTTPS", 400, "Inbound", "Allow", "Tcp", "443", "", ""], # Enable https traffic from any
        ["Allow-SQL", 500, "Inbound", "Allow", "Tcp", "1443", "", ""],  # Enable https traffic from any source

        #Standard rules
        ["Allow_All_Local_Subnet_Access", "3000", "Inbound", "Allow", "", "", "10.70.44.64/26", "10.70.44.64/26"],
        ["Allow-ICMP-Inbound", "4000", "Inbound", "Allow", "Icmp", "", "", "*"],
        ["Deny-All-Inbound", "4096", "Inbound", "Deny", "", "", "", ""]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_All", "100", "Outbound", "Allow", "", "", "", "*"]
      ]
    }
  }
}

variable "hub_network_peer" {
  type = object({
    name                = optional(string)
    resource_group_name = optional(string)
    subscription_id     = optional(string)
  })
  default = {
    name                = "vnet-ttst-hub-cnc-01-emm"
    resource_group_name = "rg-ttst-hub-cnc-01-emm"
    subscription_id     = "fdd234dc-7c17-4710-958a-2fc1fb7ba842"
  }
}

variable "resource_naming" {
  type = object({
    environment = optional(string)
    appname     = optional(string)
    instances   = list(string)
  })
  default = {
    environment = "npgen2"
    appname     = "net"
    instances   = ["01"]
  }
}