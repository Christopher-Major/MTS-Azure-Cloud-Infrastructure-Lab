<#
.SYNOPSIS
    Retrieves Azure Storage Accounts used by the
    MTS Azure Cloud Infrastructure Lab.

.DESCRIPTION
    Queries Azure Storage resources and returns
    administrative configuration information.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 10 - Administration & Automation
#>

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "MTS Azure Storage Inventory"
Write-Host "==========================="
Write-Host ""

$accounts = Get-AzStorageAccount

$results = foreach ($account in $accounts) {

    [PSCustomObject]@{
        StorageAccount = $account.StorageAccountName
        ResourceGroup  = $account.ResourceGroupName
        Location       = $account.Location
        SKU            = $account.Sku.Name
        Kind           = $account.Kind
        HTTPSOnly      = $account.EnableHttpsTrafficOnly
    }
}

$results |
    Sort-Object ResourceGroup, StorageAccount |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Storage Accounts Found: $($results.Count)"
Write-Host ""