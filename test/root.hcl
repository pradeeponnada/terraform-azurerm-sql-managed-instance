# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


# When using this terragrunt config, terragrunt will generate the file "provider.tf" with the azurerm provider block before
# calling to terraform. Note that this will overwrite the `provider.tf` file if it already exists.
# The template used for the provider.tf file is located in the _envcommon/terragrunt/common_provider.tftpl file.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = templatefile("${local.path_to_provider_template}", { default_subscription_id = local.default_subscription_id, hub_subscription_id = local.common_solution.locals.hub_subscription_id, tenant_id = local.common_solution.locals.tenant_id })
}

# Configure Terragrunt to automatically store tfstate files in an Azure Storage Account.
remote_state {
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  backend = "azurerm"
  config = {
    key                  = "${local.common_solution.locals.sol_name}/${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = local.common_solution.locals.tf_state_resource_group_name
    storage_account_name = local.common_solution.locals.tf_state_storage_account_name
    container_name       = local.common_solution.locals.tf_state_container_name
    subscription_id      = local.common_solution.locals.tf_state_subscription_id
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_solution.locals,
  local.environment_vars.locals
)
