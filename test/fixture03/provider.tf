terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0, <4.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "fdd234dc-7c17-4710-958a-2fc1fb7ba842" ###
  tenant_id       = "fd6fb306-2acd-4fae-a721-c8f5714b622e" ###
}