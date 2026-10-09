
# Phase 7 — Security

## Overview

Phase 7 introduces Azure Key Vault to the Major Technology Services (MTS) Azure Cloud Infrastructure Lab.

The phase focuses on centralized secret management, Azure role-based access control (RBAC), secure credential handling, diagnostic logging, and operational monitoring.

An initial attempt to access Key Vault secrets was denied despite the administrative account having an inherited Azure Owner role. The authorization issue was investigated and resolved by assigning the Key Vault Secrets Officer role directly to the vault.

Following the RBAC correction, a storage account access key was stored as a Key Vault secret. Diagnostic settings were configured for the existing Log Analytics workspace, and Azure Monitor metrics were used to validate Key Vault service activity.

---

## Existing Environment

Phase 7 builds on the Azure resources and identity controls established during Phases 1–6.

| Resource | Configuration |
|---|---|
| Subscription | Azure for Students |
| Region | Central US |
| Core Resource Group | `rg-mts-core-lab-01` |
| Log Analytics Workspace | `law-mts-core-lab-01` |
| Existing Storage | Azure Storage Account from Phase 6 |
| Identity Platform | Microsoft Entra ID |
| Authorization | Azure RBAC |

The Key Vault was deployed into the existing Core resource group rather than a separate security resource group.

---

## Key Vault Deployment

An Azure Key Vault was deployed with the following configuration.

| Setting | Configuration |
|---|---|
| Key Vault | `kv-mts-core-lab-01` |
| Resource Group | `rg-mts-core-lab-01` |
| Region | Central US |
| Pricing Tier | Standard |
| Permission Model | Azure RBAC |
| Soft Delete | Enabled |
| Deleted Vault Retention | 90 days |
| Purge Protection | Disabled |

![Key Vault Basics](../../Screenshots/07-Security/01-Key-Vault-Basics.PNG)

Soft delete was enabled to retain deleted vault objects during the configured recovery period.

Purge protection was not enabled for this lab deployment. This preserved cleanup flexibility but reduced protection against permanent deletion compared with a purge-protected vault.

### RBAC Permission Model

Azure RBAC was selected as the Key Vault permission model during deployment.

![Key Vault RBAC Configuration](../../Screenshots/07-Security/02-Key-Vault-RBAC-Configuration.PNG)

This model uses Azure role assignments to authorize Key Vault data-plane operations.

The optional deployment-related resource access settings were not enabled because they were not required for the lab.

---

## Key Vault Networking

Public network access was enabled from all networks during Phase 7.

![Key Vault Networking](../../Screenshots/07-Security/03-Key-Vault-Networking.PNG)

This configuration supported interactive Azure portal administration and testing.

Network access remained separate from identity authorization. Access to protected Key Vault objects still required appropriate authentication and permissions.

The lab did not implement selected-network restrictions or a private endpoint for Key Vault.

---

## Resource Governance

The existing MTS tagging convention was applied to the Key Vault.

| Tag | Value |
|---|---|
| Environment | Lab |
| Project | MTS-Azure-Lab |
| Owner | Christopher-Major |
| Workload | Security |

![Key Vault Tags](../../Screenshots/07-Security/04-Key-Vault-Tags.PNG)

The tags identify the vault as part of the MTS Azure lab and support resource organization and cost analysis.

---

## Deployment Validation

The Key Vault configuration was reviewed before deployment.

The review included:

- Subscription and resource group
- Central US region
- Standard pricing tier
- Azure RBAC permission model
- Soft-delete configuration
- Public network access
- Resource tags

![Key Vault Validation](../../Screenshots/07-Security/05-Key-Vault-Validation.PNG)

The deployment completed successfully.

![Key Vault Deployment](../../Screenshots/07-Security/06-Key-Vault-Deployment.PNG)

### Resource Validation

The Azure portal confirmed that the vault was deployed into the existing Core resource group.

```text
Key Vault:      kv-mts-core-lab-01
Resource Group: rg-mts-core-lab-01
Region:         Central US
```

![Key Vault Overview](../../Screenshots/07-Security/07-Key-Vault-Overview.PNG)

---

## Initial IAM Baseline

The Key Vault's Access Control (IAM) configuration was reviewed before secret-management testing.

The administrative account inherited the Owner role from the subscription.

![Key Vault IAM Baseline](../../Screenshots/07-Security/08-Key-Vault-IAM-Baseline.PNG)

The Owner role provided extensive Azure resource-management permissions.

However, under the selected Key Vault RBAC permission model, that role did not automatically provide the secret data-plane permissions required for the planned operation.

---

## Initial Secret Access Test

The Key Vault Secrets interface was opened to test the administrative account's effective permissions.

Azure returned:

```text
The operation is not allowed by RBAC.
```

![Key Vault Secrets Baseline](../../Screenshots/07-Security/09-Key-Vault-Secrets-Baseline.PNG)

The account could manage the Key Vault resource but could not perform the required secret operations.

A separate access-denied result was captured during the investigation.

![Key Vault RBAC Access Denied](../../Screenshots/07-Security/13-Key-Vault-RBAC-Access-Denied.PNG)

This established the primary troubleshooting issue for the phase.

### Management Plane vs. Data Plane

| Management Plane | Key Vault Data Plane |
|---|---|
| Create or update the vault | Create secrets |
| Configure networking | Read secret values |
| Configure diagnostics | Update secrets |
| Manage Azure role assignments | Delete secrets |
| Modify resource tags | Manage secret versions |

The initial failure was an authorization issue rather than evidence that the Key Vault deployment had failed.

---

## Key Vault Diagnostic Settings

Diagnostic logging was configured to forward Key Vault telemetry to the existing Log Analytics workspace.

| Setting | Configuration |
|---|---|
| Diagnostic Setting | `diag-mts-keyvault` |
| Resource | `kv-mts-core-lab-01` |
| Category Groups | `audit`, `allLogs` |
| Destination | Log Analytics |
| Workspace | `law-mts-core-lab-01` |

![Key Vault Diagnostic Configuration](../../Screenshots/07-Security/10-Key-Vault-Diagnostic-Configuration.PNG)

The diagnostic setting was reviewed after creation.

![Key Vault Diagnostics Enabled](../../Screenshots/07-Security/11-Key-Vault-Diagnostics-Enabled.PNG)

The intended telemetry path was:

```text
Azure Key Vault
      |
      v
Diagnostic Settings
      |
      v
Log Analytics Workspace
law-mts-core-lab-01
```

The configuration established the destination for Key Vault logs. Actual audit-log ingestion was investigated separately later in the phase.

---

## Resource Group Integration

The Core resource group was reviewed after Key Vault deployment.

The environment included:

- Azure Key Vault
- Log Analytics workspace
- Azure Storage Account
- Virtual network
- Network Security Groups

![Resource Group Key Vault](../../Screenshots/07-Security/12-Resource-Group-Key-Vault.PNG)

This confirmed that the vault was integrated into the existing lab infrastructure.

---

## Storage Credential Preparation

The objective was to store the existing Azure Storage Account's primary access key in Key Vault.

The secret was named:

```text
storage-account-key-primary
```

The secret configuration was prepared through the Azure portal.

![Key Vault Secret Configuration](../../Screenshots/07-Security/14-Key-Vault-Secret-Configuration.PNG)

### Credential Protection

The source credential was obtained from the Storage Account's access-key interface.

Azure Storage provides two account keys that can support key rotation.

![Storage Access Keys Protected](../../Screenshots/07-Security/15-Storage-Access-Keys-Protected.PNG)

The credential values remained masked in the documentation.

No Storage Account key or Key Vault secret value was intentionally included in the repository.

The credential flow was:

```text
Azure Storage Account
        |
        | Primary Access Key
        v
Azure Key Vault
kv-mts-core-lab-01
        |
        v
storage-account-key-primary
```

Storing the credential in Key Vault avoids placing the secret value directly in project documentation or source code.

---

## RBAC Remediation

The initial access-denied result was investigated by reviewing the account's Azure role assignments and the Key Vault permission model.

The required secret-management permission was provided by assigning:

```text
Key Vault Secrets Officer
```

The role was scoped directly to:

```text
kv-mts-core-lab-01
```

The Azure portal displayed the assignment scope as:

```text
This resource
```

![Key Vault Secrets Officer Assignment](../../Screenshots/07-Security/16-Key-Vault-Secrets-Officer-Assignment.PNG)

### Authorization Model

```text
Administrative Identity
          |
          +----------------------------+
          |                            |
          v                            v
   Subscription Owner          Key Vault Secrets Officer
          |                            |
          v                            v
   Azure Resource                Secret Management
     Management                       |
                                       v
                              kv-mts-core-lab-01
```

The Key Vault Secrets Officer assignment provided the required secret-management permissions without extending that role across the entire subscription.

---

## Secret Creation Validation

After the role assignment became effective, the secret creation operation was repeated.

![Secret Configuration After RBAC Remediation](../../Screenshots/07-Security/17-Key-Vault-Secret-Configuration-Post-Security-Officer.PNG)

The operation completed successfully.

Azure displayed:

```text
storage-account-key-primary has been successfully created.
```

![Key Vault Secret Created](../../Screenshots/07-Security/18-Key-Vault-Secret-Created.PNG)

The successful retry confirmed that the missing data-plane authorization had been the cause of the earlier access failure.

### Secret Version Validation

The secret metadata was reviewed after creation.

```text
Secret: storage-account-key-primary
Status: Enabled
```

![Key Vault Secret Metadata](../../Screenshots/07-Security/19-Key-Vault-Secret-Metadata.PNG)

The secret value was not displayed in the documentation.

This confirmed successful secret creation and an enabled version without exposing the stored credential.

---

## Diagnostic Configuration Review

The Key Vault diagnostic settings were reviewed again after the secret-management tests.

The configuration remained:

```text
Diagnostic Setting: diag-mts-keyvault
Category Groups:    audit, allLogs
Destination:        Log Analytics
Workspace:          law-mts-core-lab-01
```

![Key Vault Diagnostics Configuration](../../Screenshots/07-Security/20-Key-Vault-Diagnostics-Configuration.PNG)

This confirmed that the diagnostic setting remained configured after the authorization and secret-management operations.

---

## Log Analytics Investigation

The Log Analytics workspace was queried to investigate Key Vault audit telemetry.

### Key Vault Audit Table

The following query was attempted:

```kusto
AZKVAuditLogs
| where TimeGenerated > ago(30m)
| project TimeGenerated,
          OperationName,
          ResultSignature,
          CallerIpAddress
| order by TimeGenerated desc
```

### Azure Diagnostics Table

A second query targeted Key Vault records in the Azure Diagnostics table.

```kusto
AzureDiagnostics
| where TimeGenerated > ago(30m)
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| order by TimeGenerated desc
```

During the validation window, neither `AZKVAuditLogs` nor `AzureDiagnostics` was available in the workspace schema.

The available telemetry tables included:

```text
AzureMetrics
StorageBlobLogs
```

### Investigation Result

The Key Vault diagnostic setting was confirmed as configured and targeted to the intended workspace.

However, Key Vault audit-log ingestion was not independently verified during this phase.

The missing tables were documented as an unresolved telemetry-validation limitation rather than presented as a successful log-ingestion test.

Additional Azure Cloud Shell validation was considered but could not be completed because Cloud Shell was unavailable in the lab tenant environment.

---

## Azure Monitor Metrics Validation

Azure Monitor Metrics was used to independently verify Key Vault service activity.

The selected metric was:

```text
Total Service API Hits
```

The metric was split by:

```text
Activity Type
```

Observed activity types included:

```text
secret
vault
```

![Key Vault Service API Metrics](../../Screenshots/07-Security/21-Key-Vault-Service-API-Metrics.PNG)

The metric confirmed that the Key Vault service was processing API operations during the lab.

This provided operational evidence of service activity but did not replace the missing Key Vault audit-log ingestion evidence.

---

## Troubleshooting Results

| Issue | Investigation | Result |
|---|---|---|
| Secret access denied | Reviewed inherited Owner role and Key Vault RBAC | Missing data-plane permission identified |
| Secret creation unsuccessful | Evaluated available Key Vault roles | Key Vault Secrets Officer selected |
| RBAC change not immediately effective | Allowed time for role propagation | Secret creation subsequently succeeded |
| Key Vault audit tables unavailable | Queried expected Log Analytics tables | Ingestion not verified |
| Diagnostic configuration questioned | Reviewed diagnostic setting and workspace destination | Configuration confirmed |
| Cloud Shell unavailable | Reviewed tenant access limitation | Additional CLI validation not completed |
| Service activity required validation | Reviewed Azure Monitor metrics | `secret` and `vault` activity observed |

The authorization issue was resolved through an appropriately scoped role assignment.

The audit-log ingestion limitation remained documented.

---

## Security Observations

### Least-Privilege Authorization

Key Vault Secrets Officer was assigned directly at the vault resource scope.

This avoided granting the same secret-management role across the subscription or unrelated resources.

### Credential Confidentiality

The Storage Account access key was stored in Key Vault without publishing its value.

The repository should not contain:

- Storage Account keys
- Connection strings containing credentials
- Key Vault secret values
- Shared Access Signature tokens
- Authentication tokens
- Private keys

### Network Access

The vault retained public network access from all networks during testing.

A more restrictive implementation could use selected-network access, firewall rules, or private endpoints.

These controls were not implemented in Phase 7.

### Deletion Protection

Soft delete was enabled with a 90-day retention period.

Purge protection remained disabled for the lab.

### Monitoring

Diagnostic settings were configured for Log Analytics, and Azure Monitor metrics confirmed service API activity.

Key Vault audit-log ingestion was not verified during the available testing window.

---

## Phase 7 Verification

Phase 7 established and validated the Key Vault security configuration:

- Azure Key Vault deployed in the Core resource group
- Standard pricing tier selected
- Azure RBAC permission model selected during deployment
- Soft delete enabled with 90-day retention
- Purge protection state documented
- Public network access configuration reviewed
- Resource tags applied
- Deployment and resource overview validated
- Inherited Owner permissions reviewed
- Initial secret-access denial captured
- Management-plane and data-plane permissions distinguished
- Key Vault diagnostic setting configured
- Log Analytics destination confirmed
- Storage Account credential prepared without exposing its value
- Key Vault Secrets Officer assigned at vault scope
- Secret creation successfully repeated after RBAC remediation
- `storage-account-key-primary` created
- Enabled secret version verified
- Final diagnostic configuration reviewed
- Log Analytics audit-table availability investigated
- Cloud Shell limitation documented
- Azure Monitor service API activity confirmed

The primary secret-management and RBAC objectives were completed.

Key Vault audit-log ingestion remained unverified, and the vault retained public network access.

**Phase 7 Status: Complete**

---

## Next Phase

**Phase 8 — Monitoring & Logging**

Phase 8 expands the Azure monitoring environment by validating resource telemetry, alerting, and operational visibility.

The next phase builds on the Log Analytics workspace, Storage diagnostics, Key Vault configuration, and Azure Monitor capabilities introduced during the earlier phases.
