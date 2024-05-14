# Description
This module creates a Key Vault to hold secrets.
* Supports RBAC security for the Key Vault.  Following roles are supported:
  * Key Vault Administrator
  * reader_objects_ids are added to "Key Vault Reader" and "Key Vault Secrets User"
* Supports network ACLs with default deny.

# References: 
 * [Azure built-in roles for Key Vault data plane operations](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0.0, <4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0.0, <4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_private_endpoint.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.rbac_keyvault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_secrets_users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_objects_ids"></a> [admin\_objects\_ids](#input\_admin\_objects\_ids) | Ids of the objects that can do all operations on all keys, secrets and certificates | `list(string)` | `[]` | no |
| <a name="input_create_private_endpoint"></a> [create\_private\_endpoint](#input\_create\_private\_endpoint) | Will create a service endpoint if set to True | `string` | `false` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | specificy value Deny if Keyvault needs to allowed only by private networks. Possible values are Deny and Allow. | `string` | `"Allow"` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `bool` | `true` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault. | `list(any)` | `[]` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name of the Key Vault | `string` | n/a | yes |
| <a name="input_kv_private_dns_zone_ids"></a> [kv\_private\_dns\_zone\_ids](#input\_kv\_private\_dns\_zone\_ids) | Private DNS Zone Ids for the blob service of Azure Storage Account. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group will be created. | `string` | n/a | yes |
| <a name="input_network_acl_bypass"></a> [network\_acl\_bypass](#input\_network\_acl\_bypass) | specifies which traffic can bypass the network rules. Possible values are AzureServices and None. | `string` | `"None"` | no |
| <a name="input_private_dns_zone_group_name"></a> [private\_dns\_zone\_group\_name](#input\_private\_dns\_zone\_group\_name) | The name of the Private DNS Zone Group. | `string` | `"private-dns-zone-group"` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID used for private endpoint. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for this Key Vault. Defaults to true. | `bool` | `false` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Enable Purge Protection the the Key Vault.  Once enabled, it cannot be disabled. | `bool` | `false` | no |
| <a name="input_reader_objects_ids"></a> [reader\_objects\_ids](#input\_reader\_objects\_ids) | Ids of the objects that can read all keys, secrets and certificates | `list(string)` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group to create the resources in. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The Name of the SKU used for this Key Vault. Possible values are: Standard, and Premium. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `number` | `7` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags for Azure Resources | `map(string)` | <pre>{<br>  "TFLevel": "L0",<br>  "costCenter": "",<br>  "environment": "Production",<br>  "managedBy": "Terraform",<br>  "owner": ""<br>}</pre> | no |
| <a name="input_virtual_network_subnet_ids"></a> [virtual\_network\_subnet\_ids](#input\_virtual\_network\_subnet\_ids) | A list of subnet resource ids that can communicate with the Storage Account. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_id"></a> [kv\_id](#output\_kv\_id) | The location used for the Key Vault. |
| <a name="output_kv_name"></a> [kv\_name](#output\_kv\_name) | The name of the Key Vault. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->