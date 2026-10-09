<#
.SYNOPSIS
    Exports the MTS Azure resource inventory to CSV.

.DESCRIPTION
    Retrieves Azure Resource Manager inventory information
    and exports the results as a structured administrative report.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 10 - Administration & Automation
#>

$ErrorActionPreference = "Stop"

$exportPath = Join-Path `
    $PSScriptRoot `
    "MTS-Azure-Resource-Inventory.csv"

$resources = Get-AzResource |
    Select-Object Name,
                  ResourceType,
                  ResourceGroupName,
                  Location,
                  @{Name="Environment";Expression={$_.Tags["Environment"]}},
                  @{Name="Project";Expression={$_.Tags["Project"]}},
                  @{Name="ManagedBy";Expression={$_.Tags["ManagedBy"]}}

$resources |
    Sort-Object ResourceGroupName,
                ResourceType,
                Name |
    Export-Csv `
        -Path $exportPath `
        -NoTypeInformation `
        -Encoding UTF8

Write-Host ""
Write-Host "MTS Azure Resource Inventory Export"
Write-Host "==================================="
Write-Host ""
Write-Host "Resources exported: $($resources.Count)"
Write-Host "Output: $exportPath"
Write-Host ""