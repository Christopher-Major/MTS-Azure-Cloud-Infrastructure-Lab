output "resource_group_name" {
  description = "Name of the Terraform-managed resource group"
  value       = azurerm_resource_group.iac_lab.name
}

output "resource_group_location" {
  description = "Azure region of the Terraform-managed resource group"
  value       = azurerm_resource_group.iac_lab.location
}

output "resource_group_id" {
  description = "Azure resource ID of the Terraform-managed resource group"
  value       = azurerm_resource_group.iac_lab.id
}
output "storage_account_name" {
  description = "Name of the Terraform-managed storage account"
  value       = azurerm_storage_account.iac_storage.name
}

output "storage_account_id" {
  description = "Azure resource ID of the Terraform-managed storage account"
  value       = azurerm_storage_account.iac_storage.id
}
output "storage_container_name" {
  description = "Name of the Terraform-managed blob container"
  value       = azurerm_storage_container.iac_container.name
}