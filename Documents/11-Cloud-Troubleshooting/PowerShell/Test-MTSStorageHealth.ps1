<#
.SYNOPSIS
    Validates security-related configuration of the
    MTS Terraform-managed Azure Storage Account.

.DESCRIPTION
    Checks the storage account for expected security
    configuration and reports conditions requiring
    administrative attention.

.NOTES
    Project: MTS Azure Cloud Infrastructure Lab
    Phase: 11 - Cloud Troubleshooting
    Incident: 02 - Storage Configuration
#>

$ErrorActionPreference = "Stop"

$ResourceGroup = "rg-mts-iac-lab-01"
$StorageAccount = "stmtsterraformlab01"

Write-Host ""
Write-Host "MTS Storage Configuration Diagnostic"
Write-Host "===================================="
Write-Host ""

$storage = Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroup `
    -Name $StorageAccount

$results = @()

$results += [PSCustomObject]@{
    Check    = "Provisioning State"
    Expected = "Succeeded"
    Actual   = $storage.ProvisioningState
    Result   = if ($storage.ProvisioningState -eq "Succeeded") {
        "PASS"
    } else {
        "FAIL"
    }
}

$results += [PSCustomObject]@{
    Check    = "Minimum TLS"
    Expected = "TLS1_2"
    Actual   = $storage.MinimumTlsVersion
    Result   = if ($storage.MinimumTlsVersion -eq "TLS1_2") {
        "PASS"
    } else {
        "FAIL"
    }
}

$results += [PSCustomObject]@{
    Check    = "HTTPS Only"
    Expected = "True"
    Actual   = $storage.EnableHttpsTrafficOnly
    Result   = if ($storage.EnableHttpsTrafficOnly -eq $true) {
        "PASS"
    } else {
        "FAIL"
    }
}

$results |
    Format-Table Check, Expected, Actual, Result -AutoSize

Write-Host ""

$failed = @($results | Where-Object Result -eq "FAIL").Count

if ($failed -eq 0) {
    Write-Host "Storage configuration validation PASSED."
}
else {
    Write-Host "Storage configuration validation FAILED."
    Write-Host "Failed checks: $failed"
}

Write-Host ""