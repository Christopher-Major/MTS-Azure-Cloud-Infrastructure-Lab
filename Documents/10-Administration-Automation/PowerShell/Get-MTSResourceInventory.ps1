<#
.SYNOPSIS
    Generates an inventory of Azure resources in the
    MTS Azure Cloud Infrastructure Lab.

.DESCRIPTION
    Queries Azure Resource Manager through the Az PowerShell
    module and returns resource name, resource type,
    resource group, and Azure region.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 10 - Administration & Automation
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "MTS Azure Resource Inventory"
Write-Host "============================"
Write-Host ""

$context = Get-AzContext

if (-not $context) {
    Write-Error "No active Azure PowerShell context was detected."
    exit 1
}

Write-Host "Subscription: $($context.Subscription.Name)"
Write-Host ""

$resources = Get-AzResource |
    Select-Object Name,
                  ResourceType,
                  ResourceGroupName,
                  Location |
    Sort-Object ResourceGroupName,
                ResourceType,
                Name

$resources | Format-Table -AutoSize

Write-Host ""
Write-Host "Total Resources: $($resources.Count)"
Write-Host ""