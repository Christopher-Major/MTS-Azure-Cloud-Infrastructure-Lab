# Phase 09 - Infrastructure as Code
# Microsoft Azure Terraform Lab

resource "azurerm_resource_group" "iac_lab" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Phase       = "09"
  }
}
resource "azurerm_storage_account" "iac_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.iac_lab.name
  location                 = azurerm_resource_group.iac_lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Phase       = "09"
  }
}
resource "azurerm_storage_container" "iac_container" {
  name                  = "terraform-lab"
  storage_account_id    = azurerm_storage_account.iac_storage.id
  container_access_type = "private"
}