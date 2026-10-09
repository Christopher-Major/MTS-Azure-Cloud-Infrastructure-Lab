# Incident 01 — Azure Storage Security Configuration

## Incident Summary

A controlled configuration issue was introduced into the Terraform-managed Azure Storage Account `stmtsterraformlab01` to simulate a cloud security configuration incident.

The exercise focused on identifying configuration drift from the expected storage security baseline, validating the issue through Azure PowerShell and Azure CLI, applying remediation, and confirming that the storage account returned to its expected configuration.

---

## Affected Resource

| Property | Value |
|---|---|
| Resource Type | Azure Storage Account |
| Storage Account | `stmtsterraformlab01` |
| Resource Group | `rg-mts-iac-lab-01` |
| Region | Central US |
| Management Source | Terraform |
| Blob Container | `terraform-lab` |

---

## Expected Configuration

The established storage baseline required:

- Provisioning state: `Succeeded`
- Minimum TLS version: `TLS1_2`
- HTTPS-only traffic: `True`
- Terraform blob container: `terraform-lab`
- Blob container public access: disabled

These settings represented the expected operational and security configuration for the Terraform-managed storage environment.

---

## Incident Condition

The storage account's minimum TLS configuration was intentionally modified from the expected `TLS1_2` baseline.

This created a controlled configuration-drift scenario in which the deployed Azure resource no longer met the established security requirement.

---

## Investigation

Azure PowerShell was used to inspect the storage account configuration:

    Get-AzStorageAccount `
        -ResourceGroupName "rg-mts-iac-lab-01" `
        -Name "stmtsterraformlab01" |
        Select-Object StorageAccountName,
                      ResourceGroupName,
                      Location,
                      Kind,
                      @{Name="SKU";Expression={$_.Sku.Name}},
                      EnableHttpsTrafficOnly,
                      MinimumTlsVersion,
                      AllowBlobPublicAccess |
        Format-List

The Terraform-managed blob container was also validated:

    $storage = Get-AzStorageAccount `
        -ResourceGroupName "rg-mts-iac-lab-01" `
        -Name "stmtsterraformlab01"

    Get-AzStorageContainer `
        -Context $storage.Context |
        Select-Object Name, PublicAccess |
        Format-Table -AutoSize

Azure CLI was then used to provide independent cross-tool validation:

    az storage account show `
        --name stmtsterraformlab01 `
        --resource-group rg-mts-iac-lab-01 `
        --query "{Name:name,MinimumTLS:minimumTlsVersion,HTTPSOnly:enableHttpsTrafficOnly,ProvisioningState:provisioningState,Location:location}" `
        --output table

The investigation verified the storage account's operational state and exposed the configuration that differed from the established security baseline.

---

## Root Cause

The incident was caused by an intentional administrative configuration change that moved the storage account away from the required `TLS1_2` baseline.

This simulated a real-world configuration-drift scenario in which a cloud resource no longer complied with an established security requirement following an administrative change.

---

## Remediation

The storage account was returned to the required TLS configuration using Azure PowerShell:

    Set-AzStorageAccount `
        -ResourceGroupName "rg-mts-iac-lab-01" `
        -Name "stmtsterraformlab01" `
        -MinimumTlsVersion TLS1_2

Azure successfully applied the configuration change.

The storage account was queried again after remediation to verify that the expected security setting had been restored.

---

## Post-Remediation Validation

A dedicated PowerShell diagnostic script, `Test-MTSStorageHealth.ps1`, was created to provide repeatable validation of the storage configuration.

The script validated three key configuration requirements:

| Check | Expected |
|---|---|
| Provisioning State | `Succeeded` |
| Minimum TLS | `TLS1_2` |
| HTTPS Only | `True` |

The final diagnostic returned:

    MTS Storage Configuration Diagnostic

    Check                Expected    Actual       Result
    -----                --------    ------       ------
    Provisioning State   Succeeded   Succeeded    PASS
    Minimum TLS          TLS1_2      TLS1_2       PASS
    HTTPS Only           True        True         PASS

    Storage configuration validation PASSED.

Azure CLI independently confirmed:

- Provisioning state: `Succeeded`
- Minimum TLS: `TLS1_2`
- HTTPS-only traffic: `True`
- Location: `centralus`

The Terraform-managed blob container was also confirmed to remain available:

    Container
    ---------
    terraform-lab

---

## Resolution

**Status: RESOLVED**

The storage account was successfully returned to the established security baseline.

Post-remediation validation confirmed that:

- The storage account was successfully provisioned.
- Minimum TLS was restored to `TLS1_2`.
- HTTPS-only traffic remained enabled.
- The Terraform-managed blob container remained available.
- The dedicated storage diagnostic completed successfully.
- Azure PowerShell and Azure CLI returned consistent results.

No additional remediation was required.

---

## Operational Lessons

This incident demonstrated the importance of:

- Establishing known-good cloud configuration baselines.
- Detecting and investigating configuration drift.
- Validating security settings using multiple administrative tools.
- Using scripted health checks for repeatable diagnostics.
- Confirming remediation rather than assuming a successful configuration command restored the expected state.
- Separating infrastructure provisioning from day-to-day operational troubleshooting.
- Preserving infrastructure resources while correcting configuration-level security issues.

The exercise also demonstrated how Azure PowerShell and Azure CLI can provide independent views of the same Azure resource during investigation and validation.

---

## Skills Demonstrated

- Azure Storage administration
- Azure PowerShell
- Azure CLI
- Configuration drift analysis
- TLS security configuration
- Cloud security troubleshooting
- Cross-tool resource validation
- PowerShell diagnostic scripting
- Root-cause analysis
- Post-remediation verification

---

## Final Incident Status

**RESOLVED — Storage configuration restored and validated.**
