<#
.SYNOPSIS
    Validates critical resources in the
    MTS Azure Cloud Infrastructure Lab.

.DESCRIPTION
    Verifies Azure PowerShell authentication and checks
    for critical resource groups and Terraform-managed
    Azure resources.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 10 - Administration & Automation
#>

$ErrorActionPreference = "Stop"

$tests = @()

function Add-TestResult {

    param (
        [string]$Test,
        [bool]$Passed,
        [string]$Details
    )

    $script:tests += [PSCustomObject]@{
        Test    = $Test
        Result  = if ($Passed) { "PASS" } else { "FAIL" }
        Details = $Details
    }
}

Write-Host ""
Write-Host "MTS Azure Environment Validation"
Write-Host "================================"
Write-Host ""

# Azure context

$context = Get-AzContext

Add-TestResult `
    -Test "Azure PowerShell Context" `
    -Passed ($null -ne $context) `
    -Details $(if ($context) {
        $context.Subscription.Name
    } else {
        "No authenticated Azure context"
    })

# Core resource group

$coreRG = Get-AzResourceGroup `
    -Name "rg-mts-core-lab-01" `
    -ErrorAction SilentlyContinue

Add-TestResult `
    -Test "Core Resource Group" `
    -Passed ($null -ne $coreRG) `
    -Details "rg-mts-core-lab-01"

# Management resource group

$managementRG = Get-AzResourceGroup `
    -Name "rg-mts-management-lab-01" `
    -ErrorAction SilentlyContinue

Add-TestResult `
    -Test "Management Resource Group" `
    -Passed ($null -ne $managementRG) `
    -Details "rg-mts-management-lab-01"

# Monitoring resource group

$monitoringRG = Get-AzResourceGroup `
    -Name "rg-mts-monitoring-lab-01" `
    -ErrorAction SilentlyContinue

Add-TestResult `
    -Test "Monitoring Resource Group" `
    -Passed ($null -ne $monitoringRG) `
    -Details "rg-mts-monitoring-lab-01"

# Terraform resource group

$terraformRG = Get-AzResourceGroup `
    -Name "rg-mts-iac-lab-01" `
    -ErrorAction SilentlyContinue

Add-TestResult `
    -Test "Terraform Resource Group" `
    -Passed ($null -ne $terraformRG) `
    -Details "rg-mts-iac-lab-01"

# Terraform storage account

$terraformStorage = Get-AzStorageAccount `
    -ResourceGroupName "rg-mts-iac-lab-01" `
    -Name "stmtsterraformlab01" `
    -ErrorAction SilentlyContinue

Add-TestResult `
    -Test "Terraform Storage Account" `
    -Passed ($null -ne $terraformStorage) `
    -Details "stmtsterraformlab01"

# Terraform blob container

$containerPassed = $false

if ($terraformStorage) {

    try {

        $storageContext = $terraformStorage.Context

        $container = Get-AzStorageContainer `
            -Name "terraform-lab" `
            -Context $storageContext `
            -ErrorAction Stop

        $containerPassed = ($null -ne $container)

    }
    catch {

        $containerPassed = $false
    }
}

Add-TestResult `
    -Test "Terraform Blob Container" `
    -Passed $containerPassed `
    -Details "terraform-lab"

# Results

$tests | Format-Table -AutoSize

$passed = ($tests | Where-Object Result -eq "PASS").Count
$failed = ($tests | Where-Object Result -eq "FAIL").Count

Write-Host ""
Write-Host "Passed: $passed"
Write-Host "Failed: $failed"
Write-Host ""

if ($failed -eq 0) {

    Write-Host "MTS Azure environment validation PASSED."

}
else {

    Write-Host "MTS Azure environment validation detected failures."

}