variable "sqlmi_name" {
  type        = string
  description = "The name of the SQL Managed Instance"
}

variable "license_type" {
  type        = string
  description = "Type of license the Managed Instance will use. Possible values are LicenseIncluded and BasePrice."
  default     = "BasePrice"
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for the SQL Managed Instance. Valid values include GP_Gen4, GP_Gen5, GP_Gen8IM, GP_Gen8IH, BC_Gen4, BC_Gen5, BC_Gen8IM or BC_Gen8IH."
  default     = "GP_Gen5"
}

variable "storage_size_in_gb" {
  type        = number
  description = "Maximum storage space for the SQL Managed instance. This should be a multiple of 32 (GB)."
  default     = 32
}

variable "vcores" {
  type        = number
  description = "Number of cores that should be assigned to the SQL Managed Instance. Values can be 8, 16, or 24 for Gen4 SKUs, or 4, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48, 56, 64, 80, 96 or 128 for Gen5 SKUs."
  default     = 4
}

variable "minimum_tls_version" {
  type        = number
  description = "(Optional) The Minimum TLS Version. Default value is 1.2 Valid values include 1.0, 1.1, 1.2."
  default     = 1.2
}

variable "proxy_override" {
  type        = string
  description = "(Optional) Specifies how the SQL Managed Instance will be accessed. Default value is Default. Valid values include Default, Proxy, and Redirect."
  default     = "Default"
}

variable "public_data_endpoint_enabled" {
  type        = bool
  description = "(Optional) Is the public data endpoint enabled? Default value is false."
  default     = false
}

variable "storage_account_type" {
  type        = string
  description = "(Optional) Specifies the storage account type used to store backups for this database. Changing this forces a new resource to be created. Possible values are GRS, LRS and ZRS. Defaults to GRS."
  default     = "GRS"
}

variable "zone_redundant_enabled" {
  type        = bool
  description = "(Optional) Specifies whether or not the SQL Managed Instance is zone redundant. Defaults to false."
  default     = false
}

/***** COMMON VARIABLES *****/

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group to create the resources in."
}

variable "location" {
  type        = string
  description = "The location/region where the resource group will be created."
}

variable "tags" {
  type        = map(string)
  description = "List of tags for Azure Resources"
  default = {
    environment = "Production",
    costCenter  = "",
    managedBy   = "Terraform",
    owner       = "",
    TFLevel     = "L0"
  }
}

# variable "sqlmi_subnet_name" {
#   type        = string
#   description = "The name of SQLMI subnet in which delegation needs to be created."
# }

# variable "vnet_name" {
#   type        = string
#   description = "The name of SQLMI vnet name."
# }

variable "admin_username" {
  type        = string
  description = "The name of SQLMI Administrator Login User name."
}

variable "generate_admin_password" {
  type        = bool
  description = "Admin Login Password auto generation"
  default     = false
}

variable "store_admin_password_in_kv" {
  type        = bool
  description = "Store Admin Password in Key Vault enablement"
  default     = false
}

# variable "kv_name" {
#   type        = string
#   description = "(Optional) The name Azure Key Vault in which the secrets should be stored."
#   default     = null
# }

# variable "key_vault_rg_name" {
#   type        = string
#   description = "(Optional) The name of Azure Key Vault Resource Group"
#   default     = null
# }

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the SQL Managed Instance will be deployed."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the key vault where the password is stored."
}

/***************************************************************/
/*** Private End-points
/***************************************************************/

# variable "create_private_endpoint" {
#   type        = string
#   default     = false
#   description = "Will create a service endpoint if set to True"
# }

# variable "private_dns_zone_group_name" {
#   type        = string
#   description = "The name of the Private DNS Zone Group. "
#   default     = "private-dns-zone-group"
# }

# variable "private_endpoint_subnet_id" {
#   type        = string
#   description = "Subnet ID used for private endpoint."
#   default     = null
# }

# variable "kv_private_dns_zone_ids" {
#   type        = list(string)
#   description = "Private DNS Zone Ids for the blob service of Azure Storage Account."
#   default     = null
# }


