<#
.SYNOPSIS
    Performs operational health checks against the
    MTS Azure Cloud Infrastructure Lab.

.DESCRIPTION
    Evaluates Azure context, virtual machine state,
    network infrastructure, and critical storage
    resources for troubleshooting purposes.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 11 - Cloud Troubleshooting & Incident Response
#>

$ErrorActionPreference = "Stop"

$results = @()

function Add-HealthResult {

    param (
        [string]$Component,
        [string]$Status,
        [string]$Details
    )

    $script:results += [PSCustomObject]@{
        Component = $Component
        Status    = $Status
        Details   = $Details
    }
}

# Azure context

$context = Get-AzContext

Add-HealthResult `
    -Component "Azure Context" `
    -Status $(if ($context) { "HEALTHY" } else { "FAILED" }) `
    -Details $(if ($context) {
        $context.Subscription.Name
    } else {
        "No authenticated context"
    })

# Virtual machines

$vms = Get-AzVM -Status

foreach ($vm in $vms) {

    $powerState = (
        $vm.Statuses |
        Where-Object Code -like "PowerState/*"
    ).DisplayStatus

    Add-HealthResult `
        -Component $vm.Name `
        -Status $(if ($powerState -eq "VM running") {
            "HEALTHY"
        } else {
            "ATTENTION"
        }) `
        -Details $powerState
}

# Virtual network

$vnet = Get-AzVirtualNetwork `
    -Name "vnet-mts-lab-01" `
    -ResourceGroupName "rg-mts-core-lab-01" `
    -ErrorAction SilentlyContinue

Add-HealthResult `
    -Component "Core Virtual Network" `
    -Status $(if ($vnet) { "HEALTHY" } else { "FAILED" }) `
    -Details "vnet-mts-lab-01"

# Terraform storage

$storage = Get-AzStorageAccount `
    -ResourceGroupName "rg-mts-iac-lab-01" `
    -Name "stmtsterraformlab01" `
    -ErrorAction SilentlyContinue

Add-HealthResult `
    -Component "Terraform Storage" `
    -Status $(if ($storage) { "HEALTHY" } else { "FAILED" }) `
    -Details "stmtsterraformlab01"

$results | Format-Table -AutoSize