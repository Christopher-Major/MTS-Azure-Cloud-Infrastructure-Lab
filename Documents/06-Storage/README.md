
# Phase 6 — Storage

## Overview

Phase 6 implements Azure Storage for the Major Technology Services (MTS) Azure Cloud Infrastructure Lab.

The phase covers Storage Account deployment, Blob container configuration, Microsoft Entra authentication, Azure RBAC, diagnostic logging, and operational troubleshooting.

A Storage Blob Data Contributor role assignment was used to validate Blob data-plane access. Azure Monitor and Log Analytics were then configured to collect storage telemetry, with Kusto Query Language (KQL) used to review successful operations and investigate failed requests.

The completed phase demonstrates storage deployment, access validation, monitoring, and troubleshooting within the existing Azure environment.

---

## Existing Environment

Phase 6 builds on the infrastructure and identity configuration established during earlier phases.

| Resource | Configuration |
|---|---|
| Subscription | Azure for Students |
| Region | Central US |
| Core Resource Group | `rg-mts-core-lab-01` |
| Management Resource Group | `rg-mts-management-lab-01` |
| Monitoring Resource Group | `rg-mts-monitoring-lab-01` |
| Virtual Network | `vnet-mts-lab-01` |
| Identity Platform | Microsoft Entra ID |
| Authorization | Azure RBAC |

The storage environment uses Azure resource-management permissions and separate Blob data-plane authorization.

---

## Storage Account Deployment

An Azure Storage Account was deployed to support Blob storage, access-control testing, and diagnostic logging.

### Storage Configuration

The deployment included:

- Subscription and resource-group selection
- Storage Account naming
- Central US region
- Performance and redundancy settings
- Advanced configuration
- Network-access settings
- Security configuration
- Standardized resource tags

The configuration was reviewed before deployment.

![Storage Account Basics](../../Screenshots/06-Storage/01-Storage-Account-Basics.PNG)

![Storage Advanced Configuration](../../Screenshots/06-Storage/02-Storage-Advanced-Configuration.PNG)

### Network Configuration

The initial Storage Account network settings were documented as the baseline for later access and security testing.

![Storage Network Baseline](../../Screenshots/06-Storage/03-Storage-Network-Baseline.PNG)

### Security Configuration

Storage security settings were reviewed during deployment.

![Storage Security Configuration](../../Screenshots/06-Storage/04-Storage-Security-Configuration.PNG)

### Resource Tags

The MTS tagging standard was applied to support resource identification, ownership tracking, and cost analysis.

![Storage Resource Tags](../../Screenshots/06-Storage/05-Storage-Tags.PNG)

### Deployment Validation

The Storage Account configuration passed the Azure deployment review.

![Storage Configuration Validation](../../Screenshots/06-Storage/06-Storage-Validation.PNG)

The deployment completed successfully.

![Storage Account Deployment](../../Screenshots/06-Storage/07-Storage-Deployment.PNG)

### Storage Account Overview

The deployed Storage Account was reviewed in the Azure portal.

The Phase 6 implementation record identifies the account as:

```text
stmtstlab01
```

![Storage Account Overview](../../Screenshots/06-Storage/08-Storage-Account-Overview.PNG)

The account provides the Blob Storage resource used throughout this phase.

---

## Blob Container Configuration

A Blob container was created within the Storage Account.

| Setting | Configuration |
|---|---|
| Storage Account | `stmtstlab01` |
| Container | `container-mts-lab-data` |
| Service | Azure Blob Storage |
| Purpose | Data storage, RBAC testing, and diagnostic validation |

![Blob Container](../../Screenshots/06-Storage/09-Blob-Container.PNG)

### Blob Upload Validation

Test files were uploaded to verify that the container could store and retrieve Blob objects.

![Blob Upload Validation](../../Screenshots/06-Storage/10-Blob-Upload-Validation.PNG)

These objects were also used to generate activity for later monitoring and troubleshooting tests.

---

## Microsoft Entra Access Validation

Blob access was tested using Microsoft Entra authentication before the required Blob data-plane role was assigned.

The initial request was denied.

![Microsoft Entra Pre-RBAC Access Denied](../../Screenshots/06-Storage/11-Entra-Pre-RBAC-Access-Denied.PNG)

This demonstrated the distinction between managing an Azure Storage Account and accessing its Blob data.

Azure management-plane permissions do not automatically provide equivalent Blob data-plane permissions when Microsoft Entra authorization is used.

### Storage IAM Baseline

The Storage Account's IAM configuration was reviewed before introducing the Blob data role.

![Storage IAM Owner Baseline](../../Screenshots/06-Storage/12-Storage-IAM-Owner-Baseline.PNG)

The review established the existing resource-management permissions before the data-plane assignment.

---

## Storage Blob Data Contributor

The Azure built-in **Storage Blob Data Contributor** role was selected to authorize Blob operations using Microsoft Entra authentication.

![Storage Blob Data Contributor Role](../../Screenshots/06-Storage/13-Storage-Blob-Data-Contributor-Role.PNG)

The role assignment was completed through Azure IAM.

![Storage Blob RBAC Assignment](../../Screenshots/06-Storage/14-Storage-Blob-RBAC-Assignment.PNG)

### Access Model

```text
Microsoft Entra Identity
          |
          v
       Azure RBAC
          |
          +--------------------------+
          |                          |
          v                          v
   Management Plane              Data Plane
          |                          |
          v                          v
   Storage Resource             Blob Objects
   Configuration                     |
                                     v
                         Storage Blob Data
                            Contributor
```

The Storage Blob Data Contributor role provides Blob data permissions independently of general Storage Account management permissions.

Following the role assignment, authenticated Blob operations were successfully performed against the container.

---

## Storage Network Access

The Storage Account's network-access configuration was reviewed again during monitoring setup.

At the time of Phase 6 testing:

| Setting | Recorded State |
|---|---|
| Public Network Access | Enabled |
| Network Access | All networks |
| Network Security Perimeter | Not configured |
| Selected Network Restrictions | Not enforced |

![Storage Network Access](../../Screenshots/06-Storage/21-Storage-Network-Access.PNG)

This configuration supported the lab's access and monitoring tests but was not a fully hardened production network configuration.

Public network access does not by itself grant permission to private Blob data. Authentication and authorization requirements still apply.

Restricting network access through storage firewall rules, selected networks, or private endpoints remains a potential future hardening activity.

---

## Log Analytics Workspace

A Log Analytics workspace was deployed to centralize storage telemetry.

| Setting | Configuration |
|---|---|
| Workspace | `law-mts-core-lab-01` |
| Resource Group | `rg-mts-core-lab-01` |
| Region | Central US |
| Subscription | Azure for Students |
| Pricing | Pay-as-you-go |

![Log Analytics Workspace Creation](../../Screenshots/06-Storage/22-Log-Analytics-Creation.PNG)

The workspace provides the destination for diagnostic data generated by the Storage Account and Blob service.

### Workspace Validation

The deployed workspace was reviewed and confirmed available for log analysis.

![Log Analytics Workspace Validation](../../Screenshots/06-Storage/26-Log-Analytics-Workspace.PNG)

---

## Storage Diagnostic Settings

Diagnostic settings were configured to send storage telemetry to the Log Analytics workspace.

### Storage Account Diagnostics

| Setting | Configuration |
|---|---|
| Diagnostic Setting | `diag-mts-storage` |
| Resource | Storage Account |
| Telemetry | Transaction metrics |
| Destination | `law-mts-core-lab-01` |

![Storage Diagnostic Settings](../../Screenshots/06-Storage/23-Storage-Blob-Diagnostic-Settings.PNG)

### Blob Service Diagnostics

A separate diagnostic setting was configured for Blob operations.

| Setting | Configuration |
|---|---|
| Diagnostic Setting | `diag-mts-blob` |
| Resource | Blob service |
| Logs | Storage Read, Write, Delete |
| Metrics | Transactions |
| Destination | `law-mts-core-lab-01` |

![Blob Diagnostic Logging](../../Screenshots/06-Storage/24-Blob-Diagnostic-Logging-Config.PNG)

### Diagnostic Validation

The diagnostic configuration was reviewed after deployment.

| Storage Service | Diagnostic State |
|---|---|
| Storage Account | Enabled |
| Blob | Enabled |
| Queue | Disabled |
| Table | Disabled |
| File | Disabled |

![Diagnostic Settings Validation](../../Screenshots/06-Storage/25-Diagnostic-Settings-Enabled.PNG)

The configuration was intentionally focused on Storage Account metrics and Blob data-plane activity.

---

## Log Analytics Ingestion Validation

Blob activity was generated against:

```text
container-mts-lab-data
```

The resulting diagnostic records were successfully ingested into Log Analytics.

The records were available in:

```text
StorageBlobLogs
```

![Blob Log Analytics Query](../../Screenshots/06-Storage/27-Blob-Log-Analytics-Query.PNG)

The telemetry included fields such as:

- Time generated
- Operation name
- Authentication type
- HTTP status code
- Status text
- Resource URI

The completed telemetry path was:

```text
Azure Blob Storage
        |
        v
Diagnostic Settings
        |
        v
Log Analytics Workspace
        |
        v
StorageBlobLogs
        |
        v
KQL Analysis
```

This confirmed that the monitoring configuration was collecting Blob data-plane activity.

---

## Blob Operations Validation

Log Analytics was used to review successful and unsuccessful Blob operations.

Observed operations included:

- `ListBlobs`
- `PutBlob`
- `DeleteBlob`
- `GetBlobProperties`
- `GetBlobTags`
- `GetBlobMetadata`

![Blob Operations Validation](../../Screenshots/06-Storage/28-Log-Analytics-Blob-Operations-Validation.PNG)

Successful operations returned HTTP 200-series responses.

The telemetry also contained failed requests, including authorization errors and missing-resource responses.

These records provided data for the KQL troubleshooting exercises.

---

## KQL Operations Analysis

Kusto Query Language was used to review Blob activity associated with the test container.

### Query

```kusto
StorageBlobLogs
| where TimeGenerated > ago(24h)
| where Uri contains "container-mts-lab-data"
| project TimeGenerated,
          OperationName,
          AuthenticationType,
          StatusCode,
          StatusText,
          Uri
| order by TimeGenerated desc
```

The query filters the collected records to the target container and presents the operations in chronological order.

![KQL Storage Operations Analysis](../../Screenshots/06-Storage/32-KQL-Storage-Operations-Analysis.PNG)

### Observed Results

| Operation | HTTP Status | Result |
|---|---:|---|
| `ListBlobs` | 200 | Success |
| `DeleteBlob` | 202 | Success |
| `GetContainerServiceMetadata` | 200 | Success |
| `GetBlobProperties` | 404 | BlobNotFound |
| `GetBlobTags` | 403 | AuthorizationError |
| `GetBlobMetadata` | 200 | Success |

The results demonstrated how Blob operations could be reconstructed using their timestamps, authentication methods, status codes, and resource URIs.

---

## KQL Troubleshooting Analysis

A second KQL query isolated unsuccessful Blob requests.

### Query

```kusto
StorageBlobLogs
| where TimeGenerated > ago(24h)
| where StatusCode >= 400
| project TimeGenerated,
          OperationName,
          AuthenticationType,
          StatusCode,
          StatusText,
          Uri
| order by TimeGenerated desc
```

![KQL Storage Troubleshooting Analysis](../../Screenshots/06-Storage/33-KQL-Storage-Troubleshooting-Analysis.PNG)

### Authorization Failure

A `GetBlobTags` operation using OAuth authentication returned:

```text
403 AuthorizationError
```

This identified a Blob operation that was rejected by the Storage service.

The response establishes that the request was denied, but the log entry alone does not establish the exact underlying permission or configuration issue.

### Blob Not Found

A `GetBlobProperties` request returned:

```text
404 BlobNotFound
```

The requested Blob was not found when the operation was performed.

### Container Not Found

A `GetContainerProperties` request returned:

```text
404 ContainerNotFound
```

This indicated that the requested container could not be located for that operation.

These examples demonstrate how KQL can isolate failed requests from normal storage activity and provide a starting point for troubleshooting.

---

## Final Blob Container Validation

The Blob container was reviewed after the access and monitoring tests.

Authentication was performed using a Microsoft Entra user account.

The final container included test objects such as:

```text
mts-rbac-write-test.txt
mts-storage-validation.txt
```

![Final Blob Container State](../../Screenshots/06-Storage/29-Final-Blob-Container-State.PNG)

The objects provided evidence of successful authenticated Blob operations against the monitored container.

---

## Resource Inventory

The core resource group was reviewed at the conclusion of Phase 6.

The recorded inventory included:

```text
rg-mts-core-lab-01
|
|-- law-mts-core-lab-01
|-- nsg-mts-application-01
|-- nsg-mts-management-01
|-- nsg-mts-server-01
|-- stmtstlab01
`-- vnet-mts-lab-01
```

![Final Resource Group Inventory](../../Screenshots/06-Storage/30-Final-Resource-Group-Inventory.PNG)

This confirmed the presence of the Storage Account, Log Analytics workspace, and existing network infrastructure.

---

## Azure Activity Log

The Azure Activity Log was reviewed to identify resource-management operations associated with Phase 6.

Recorded operations included:

- Workspace creation
- Diagnostic setting creation and updates
- Role assignment creation
- Storage Account updates
- Deployment validation
- Storage Account key-listing operations

![Azure Activity Log](../../Screenshots/06-Storage/31-Azure-Activity-Log.PNG)

The Activity Log provides visibility into Azure control-plane activity.

Blob diagnostic logs provide separate visibility into data-plane operations.

| Source | Purpose |
|---|---|
| Azure Activity Log | Resource configuration and management operations |
| `StorageBlobLogs` | Blob data operations and service responses |

Both sources were used to review the environment.

---

## Security and Troubleshooting Observations

### Management-Plane and Data-Plane Access

The initial Microsoft Entra access test failed before the required Blob data-plane role was assigned.

After Storage Blob Data Contributor was configured, authenticated Blob operations succeeded.

This demonstrated the importance of selecting the correct Azure RBAC role for the intended operation.

### Public Network Access

The Storage Account remained accessible through its public service endpoint during the phase.

The account still required appropriate authorization for protected data operations, but the network configuration did not restrict requests to selected networks or private endpoints.

### Diagnostic Logging

Storage Account and Blob diagnostic settings successfully forwarded telemetry to Log Analytics.

The `StorageBlobLogs` table provided operational records for storage activity.

### HTTP Error Analysis

KQL identified 403 and 404 responses associated with Blob operations.

The collected telemetry helped distinguish authorization failures from requests for resources that were not found.

---

## Phase 6 Verification

Phase 6 established and validated the Azure Storage environment:

- Azure Storage Account deployed
- Storage configuration and security settings reviewed
- Resource tags applied
- Blob container created
- Test Blob objects uploaded
- Microsoft Entra access tested before data-plane RBAC assignment
- Storage IAM baseline reviewed
- Storage Blob Data Contributor assigned
- Authenticated Blob operations validated
- Storage network-access configuration documented
- Log Analytics workspace deployed
- Storage transaction diagnostics configured
- Blob read, write, and delete logging configured
- Diagnostic configuration reviewed
- Blob telemetry ingested into `StorageBlobLogs`
- Successful Blob operations identified
- KQL used to analyze storage activity
- KQL used to isolate 403 and 404 responses
- Final Blob container state reviewed
- Core resource inventory validated
- Azure Activity Log reviewed

The phase established a functioning Blob Storage environment with identity-based access control and centralized operational logging.

Public network access remained enabled and is documented as a security-hardening opportunity.

**Phase 6 Status: Complete**

---

## Next Phase

**Phase 7 — Security**

Phase 7 expands the Azure security configuration by reviewing infrastructure security controls, access restrictions, and resource protection.

The next phase will build on the network, compute, identity, and storage resources established during Phases 1–6.
