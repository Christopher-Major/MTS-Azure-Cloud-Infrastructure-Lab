variable "resource_group_name" {
  description = "Name of the Terraform-managed resource group"
  type        = string
  default     = "rg-mts-iac-lab-01"
}

variable "location" {
  description = "Azure region used for Phase 09 resources"
  type        = string
  default     = "Central US"
}

variable "environment" {
  description = "Environment tag applied to Azure resources"
  type        = string
  default     = "Lab"
}

variable "project_name" {
  description = "Project tag applied to Azure resources"
  type        = string
  default     = "MTS-Azure-Lab"
}
variable "storage_account_name" {
  description = "Name of the Terraform-managed storage account"
  type        = string
  default     = "stmtsterraformlab01"
}