
# Microsoft Azure Cloud Infrastructure Lab

## Major Technology Services (MTS)

![Project Status](https://img.shields.io/badge/Project%20Status-Complete-brightgreen)
![Phases](https://img.shields.io/badge/Phases-12%2F12%20Complete-brightgreen)
![Microsoft Azure](https://img.shields.io/badge/Microsoft%20Azure-Cloud%20Infrastructure-0078D4)
![Networking](https://img.shields.io/badge/Networking-VNet%20%7C%20NSG-0078D4)
![Compute](https://img.shields.io/badge/Compute-Linux%20%7C%20Windows-0078D4)
![IAM](https://img.shields.io/badge/IAM-Entra%20ID%20%7C%20RBAC-6f42c1)
![Security](https://img.shields.io/badge/Security-Key%20Vault%20%7C%20TLS-6f42c1)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-844FBA)
![PowerShell](https://img.shields.io/badge/PowerShell-Administration-5391FE)
![Monitoring](https://img.shields.io/badge/Monitoring-Azure%20Monitor-success)
![Validation](https://img.shields.io/badge/Final%20Validation-10%2F10%20PASS-brightgreen)

An enterprise-style Microsoft Azure infrastructure lab designed, deployed, secured, administered, monitored, troubleshot, and validated across 12 technical phases.

The project simulates the lifecycle of a small cloud infrastructure environment using **Azure Virtual Networks, Network Security Groups, Linux and Windows virtual machines, Microsoft Entra ID, Azure RBAC, managed identities, Azure Storage, Azure Key Vault, Azure Monitor, Log Analytics, Terraform, Azure CLI, and PowerShell**.

The completed environment includes **27 Azure resources across five resource groups**, with documented configuration, operational testing, security reviews, and infrastructure validation.

**Project Status: COMPLETE — 12 of 12 Phases**

---

# Project Purpose

The purpose of this project was to move beyond isolated cloud exercises and build an Azure environment in which networking, compute, identity, storage, security, monitoring, and administrative tools operate together.

The lab began with Azure subscription planning and progressed through:

```text
Plan
  |
  v
Establish Azure Foundation
  |
  v
Configure Networking
  |
  v
Deploy Compute
  |
  v
Implement Identity & RBAC
  |
  v
Configure Storage
  |
  v
Apply Security Controls
  |
  v
Enable Monitoring
  |
  v
Deploy Infrastructure as Code
  |
  v
Automate Administration
  |
  v
Troubleshoot
  |
  v
Audit & Validate
```

The project emphasizes practical skills relevant to:

- Cloud Support Engineering
- Cloud Infrastructure Administration
- Azure Administration
- Cloud Security
- Identity & Access Management
- Infrastructure as Code
- Systems Administration
- Network Administration
- Technical Support
- Cloud Operations & Troubleshooting

The environment was built using an **Azure for Students subscription**, requiring consideration of service availability, regional restrictions, resource sizing, and ongoing cloud costs.

---

# Skills Demonstrated

![Azure](https://img.shields.io/badge/Azure-Infrastructure-0078D4)
![Networking](https://img.shields.io/badge/Networking-VNet%20%7C%20Subnetting-0078D4)
![NSG](https://img.shields.io/badge/NSG-Network%20Security-6f42c1)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624)
![Windows](https://img.shields.io/badge/Windows-Server-0078D4)
![IAM](https://img.shields.io/badge/IAM-RBAC%20%7C%20Managed%20Identity-6f42c1)
![Storage](https://img.shields.io/badge/Storage-Blob%20Storage-0078D4)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE)
![Troubleshooting](https://img.shields.io/badge/Troubleshooting-Root%20Cause-success)

### Cloud Infrastructure Administration

- Azure subscription administration
- Resource group organization
- Azure resource deployment
- Resource naming conventions
- Resource tagging and governance
- Azure Policy restriction analysis
- Regional resource availability
- Azure resource inventory
- Resource provisioning validation
- Azure cost management
- Virtual machine lifecycle administration
- Cross-service infrastructure validation

### Azure Networking

- Azure Virtual Networks
- IPv4 addressing and subnetting
- Network segmentation
- Subnet-level Network Security Groups
- Custom inbound security rules
- Azure network interfaces
- Private IP addressing
- Standard public IP configuration
- Restricted SSH administration
- Network dependency tracing
- NSG rule inspection and troubleshooting

### Compute & Systems Administration

- Ubuntu Linux virtual machines
- Windows virtual machines
- Azure VM sizing and deployment
- Managed OS disks
- Azure VM networking
- SSH key authentication
- Linux administration
- Azure CLI administration
- VM provisioning-state validation
- VM power-state troubleshooting
- Automatic shutdown configuration
- Compute cost optimization

### Identity & Access Management

- Microsoft Entra ID
- Azure Role-Based Access Control
- Resource-group authorization scopes
- Reader role assignments
- User-assigned managed identities
- Managed identity association with compute
- Read-only access validation
- Unauthorized operation testing
- Privileged role assignment review
- Azure Key Vault authorization inspection
- Least-privilege access design

### Cloud Storage & Security

- Azure Storage Accounts
- Azure Blob Storage
- Private blob containers
- Storage RBAC
- Storage diagnostic settings
- Azure Key Vault
- Secret management
- TLS 1.2 enforcement
- HTTPS-only storage configuration
- Public network access assessment
- Storage security configuration auditing
- Security baseline validation
- Configuration drift troubleshooting

### Monitoring & Logging

- Azure Monitor
- Log Analytics workspaces
- Azure Activity Logs
- Storage diagnostic logging
- Key Vault diagnostic configuration
- Kusto Query Language
- Azure metric alerts
- Azure Monitor Action Groups
- Email alert notifications
- Cost budgets and alert thresholds
- Monitoring resource validation
- Operational health reporting

### Infrastructure as Code

- Terraform CLI
- HashiCorp AzureRM provider
- Terraform configuration files
- Variables and outputs
- Resource dependencies
- Terraform-managed resource deployment
- Terraform state inspection
- Local state management
- Terraform validation
- Infrastructure drift detection
- Terraform plan review
- GitHub source control
- Terraform `.gitignore` configuration

### Administration & Automation

- Azure PowerShell
- Azure CLI
- PowerShell administrative scripting
- Azure resource inventory
- CSV inventory exports
- Storage configuration reporting
- Resource tagging validation
- Azure context verification
- Cloud health diagnostics
- Repeatable configuration checks
- PowerShell script validation
- Administrative reporting

### Troubleshooting & Incident Response

- Cloud configuration drift
- VM operational-state troubleshooting
- Azure NIC and subnet investigation
- NSG security-rule troubleshooting
- Controlled fault injection
- Root-cause analysis
- Targeted remediation
- Post-remediation validation
- Azure PowerShell and Azure CLI cross-validation
- Incident report documentation
- Infrastructure health verification

---

# Final Azure Architecture

The completed Azure environment uses a single virtual network with separate management, server, and application subnets.

Network Security Groups are associated at the subnet level.

```text
                     Microsoft Azure
                    Azure for Students
                         Central US
                             |
                             v
                     vnet-mts-lab-01
                       10.20.0.0/16
                             |
           +-----------------+-----------------+
           |                 |                 |
           v                 v                 v

    Management Subnet    Server Subnet    Application Subnet
     10.20.10.0/24      10.20.20.0/24     10.20.30.0/24
           |                 |                 |
           v                 v                 v
    nsg-mts-management  nsg-mts-server   nsg-mts-application
           |                 |
           v                 +--------------------+
    vm-mts-admin-01          |                    |
    Ubuntu Linux             v                    v
    10.20.10.4        vm-mts-linux-01       vm-mts-win-01
           |           Ubuntu Linux         Windows
           |           10.20.20.4           10.20.20.5
           |
           v
    pip-mts-admin-01
    Standard Static IPv4
    Restricted SSH
```

Supporting Azure services include:

```text
Azure Resource Groups
        |
        +-- Virtual Networks / NSGs
        |
        +-- Virtual Machines / Managed Disks
        |
        +-- Microsoft Entra ID / Azure RBAC
        |
        +-- User-Assigned Managed Identity
        |
        +-- Azure Storage / Blob Containers
        |
        +-- Azure Key Vault
        |
        +-- Azure Monitor / Log Analytics
        |
        +-- Diagnostic Settings / Alerts
        |
        +-- Action Groups / Cost Budget
        |
        +-- Terraform-Managed Infrastructure
```

The application subnet was provisioned and secured but did not contain a dedicated application VM in the final validated environment.

**Architecture Scope:** Azure-only. No VPN, Azure-to-on-premises routing, or hybrid identity synchronization was established during the 12 completed phases.

---

# Core Azure Infrastructure

## Resource Groups

The final inventory contained five resource groups.

| Resource Group | Purpose |
|---|---|
| `rg-mts-core-lab-01` | Core networking, storage, security, and monitoring resources |
| `rg-mts-management-lab-01` | Management and workload virtual machines |
| `rg-mts-monitoring-lab-01` | Monitoring and cost notification resources |
| `rg-mts-iac-lab-01` | Terraform-managed infrastructure |
| `NetworkWatcherRG` | Azure-associated network monitoring resources |

Resource organization was used to separate infrastructure responsibilities and support administration, governance, and cost review.

## Core Systems

| Resource | Role | Configuration |
|---|---|---|
| `vm-mts-admin-01` | Linux administration VM | Ubuntu / Standard_D2s_v4 |
| `vm-mts-linux-01` | Linux workload VM | Ubuntu / Standard_D2s_v4 |
| `vm-mts-win-01` | Windows workload VM | Windows / Standard_D2ds_v4 |
| `vnet-mts-lab-01` | Core virtual network | `10.20.0.0/16` |
| `pip-mts-admin-01` | Management public IP | Standard / Static IPv4 |
| `id-mts-rbac-reader-01` | User-assigned managed identity | Reader |
| `kv-mts-core-lab-01` | Azure Key Vault | Secrets and authorization testing |
| `law-mts-core-lab-01` | Log Analytics workspace | 30-day retention |

---

# Network Architecture

The Azure network uses a non-overlapping address range designed to support segmented cloud infrastructure and possible future integration with the on-premises lab.

```text
Azure VNet:       10.20.0.0/16

Management:       10.20.10.0/24
Server:           10.20.20.0/24
Application:      10.20.30.0/24
```

### Subnet and NSG Design

| Subnet | Network Security Group |
|---|---|
| `snet-mts-management-01` | `nsg-mts-management-01` |
| `snet-mts-server-01` | `nsg-mts-server-01` |
| `snet-mts-application-01` | `nsg-mts-application-01` |

### Network Interface Configuration

| VM | Private IP | Subnet |
|---|---|---|
| `vm-mts-admin-01` | `10.20.10.4` | Management |
| `vm-mts-linux-01` | `10.20.20.4` | Server |
| `vm-mts-win-01` | `10.20.20.5` | Server |

### Management Access

The management VM uses:

- A Standard static public IPv4 address
- SSH key authentication
- A custom inbound NSG rule
- TCP port 22
- A single approved source IPv4 address

The management NSG contains:

```text
Rule:          Allow-SSH-Admin
Priority:      100
Direction:     Inbound
Protocol:      TCP
Port:          22
Source:        Restricted IPv4
Action:        Allow
```

The configuration was validated as a restricted administrative access control.

Phase 12 did not perform a new live SSH connectivity test.

---

# Azure Compute

The environment contains three virtual machines deployed across the management and server subnets.

| VM | Operating System | Size | Private IP |
|---|---|---|---|
| `vm-mts-admin-01` | Ubuntu Linux | Standard_D2s_v4 | `10.20.10.4` |
| `vm-mts-linux-01` | Ubuntu Linux | Standard_D2s_v4 | `10.20.20.4` |
| `vm-mts-win-01` | Windows | Standard_D2ds_v4 | `10.20.20.5` |

### Managed Storage

```text
Management VM OS Disk:  30 GB
Linux VM OS Disk:       30 GB
Windows VM OS Disk:    127 GB

Storage Tier: Standard SSD LRS
```

### VM Lifecycle Management

All three virtual machines have automatic shutdown schedules configured for:

```text
15:00
Central Standard Time
```

At final validation:

```text
Total VMs:        3
Running:          0
Deallocated:      3
```

This configuration preserves the infrastructure while reducing active compute consumption.

Managed disks and other allocated Azure resources may continue generating charges.

---

# Microsoft Entra ID & Azure RBAC

Azure authorization was implemented using resource-scoped role assignments and a user-assigned managed identity.

### Managed Identity

```text
Identity:
id-mts-rbac-reader-01

Resource Group:
rg-mts-management-lab-01

Assigned Role:
Reader
```

The managed identity was associated with the management VM.

The lab validated read-only resource access and tested operations outside the assigned permissions.

### Authorization Model

```text
User-Assigned Managed Identity
              |
              v
       Azure RBAC Role
              |
              v
            Reader
              |
              v
    Management Resource Group
              |
              v
       Read-Only Operations
```

The design demonstrates the difference between identity authentication and authorization to perform Azure resource operations.

### Subscription Privilege Review

The final audit identified two Owner role assignments referencing one unique principal ID.

This was documented as two assignment records, not two separate privileged principals.

---

# Azure Key Vault

The environment includes:

```text
Key Vault:
kv-mts-core-lab-01

Resource Group:
rg-mts-core-lab-01

Region:
Central US
```

The Key Vault was used during the security phase for secret management and authorization-related testing.

The final validation confirmed that the Key Vault was present and reported one access policy.

The audit did not conclusively establish its current RBAC authorization mode, which remains a documented configuration-review item.

---

# Azure Storage

The environment includes two Azure Storage Accounts.

| Storage Account | Purpose |
|---|---|
| `stmtslab01` | Core lab storage |
| `stmtsterraformlab01` | Terraform-managed storage |

Storage activities included:

- Storage Account deployment
- Azure Blob Storage
- Private blob containers
- Storage RBAC
- Blob diagnostics
- Log Analytics integration
- TLS configuration
- HTTPS enforcement
- Storage security troubleshooting

### Final Storage Security Baseline

| Configuration | Core Storage | Terraform Storage |
|---|---|---|
| Minimum TLS | TLS1_2 | TLS1_2 |
| HTTPS Only | True | True |
| Provisioning | Succeeded | Succeeded |
| Public Network Access | Enabled | Enabled |
| Default Network Action | Allow | Allow |
| Account-Level Anonymous Blob Access Allowed | False | True |

Both Storage Accounts passed the tested TLS 1.2 and HTTPS-only requirements.

The Terraform-managed `terraform-lab` container was verified as private during Phase 11.

However, the Terraform Storage Account still permitted anonymous blob access to be enabled at the account level, and both accounts retained public network access.

These were documented as security-hardening opportunities rather than represented as fully hardened production configurations.

---

# Azure Monitoring & Logging

The monitoring implementation uses Azure Monitor, Log Analytics, diagnostic settings, metric alerts, and action groups.

### Log Analytics

```text
Workspace:
law-mts-core-lab-01

Region:
Central US

Retention:
30 Days
```

### Diagnostic Logging

Monitoring activities included:

- Azure Activity Log review
- Storage diagnostic configuration
- Blob logging
- Key Vault diagnostic configuration
- Log Analytics queries
- Kusto Query Language
- Azure resource metrics

### Storage Transaction Alert

```text
Alert:
alert-mts-storage-transactions

Severity:
3

Status:
Enabled
```

Phase 08 demonstrated the alert firing, resolving, and delivering an email notification.

Phase 12 confirmed the alert remained enabled but did not generate a new alert.

### Action Groups

```text
ag-mts-core-lab-01
ag-mts-cost-alerts-lab-01
```

These support monitoring notifications and cost-management workflows.

---

# Cost Management & Governance

The project was developed using Azure for Students.

Regional restrictions and available VM sizes influenced deployment decisions.

### Budget Configuration

```text
Budget:
budget-mts-azure-lab-01

Monthly Budget:
$25
```

Configured budget thresholds included:

```text
Actual Spend:
50%
80%
100%

Forecast Spend:
100%
```

### Governance Tags

Resource tagging used fields including:

```text
Environment
Project
Owner
ManagedBy
Workload
```

The final Phase 12 audit identified:

```text
Total Resources:     27
Tagged Resources:    22
Untagged Resources:   5
Tag Coverage:       81.5%
```

The remaining tagging exceptions were documented for future review.

### Cost Controls

- Azure for Students subscription
- Regional availability review
- VM size selection
- Monthly budget monitoring
- Budget alert thresholds
- Automatic VM shutdown
- Manual VM deallocation
- Resource inventory and cost review

These controls reduced unnecessary consumption but did not eliminate charges from all allocated resources.

---

# Terraform Infrastructure as Code

Phase 09 introduced Terraform for repeatable Azure resource provisioning.

### Tooling

```text
Terraform CLI:       1.16.x
AzureRM Provider:    4.81.0
State Backend:       Local
```

### Terraform-Managed Infrastructure

```text
Terraform
    |
    v
rg-mts-iac-lab-01
    |
    v
stmtsterraformlab01
    |
    v
terraform-lab
Private Blob Container
```

### Managed Resources

```text
azurerm_resource_group.iac_lab
azurerm_storage_account.iac_storage
azurerm_storage_container.iac_container
```

### Terraform Files

```text
Documents/
└── 09-Infrastructure-as-Code/
    └── terraform/
        ├── .gitignore
        ├── main.tf
        ├── outputs.tf
        ├── providers.tf
        └── variables.tf
```

The configuration uses:

- AzureRM provider declarations
- Terraform variables
- Resource dependencies
- Resource tagging
- Terraform outputs
- Private blob container configuration

### Validation

```powershell
terraform validate
```

Result:

```text
Success! The configuration is valid.
```

Phase 12 also performed Terraform drift detection.

```text
No changes. Your infrastructure matches the configuration.
```

No changes were proposed for the three Terraform-managed resources.

The project used local Terraform state. Remote state storage, CI/CD deployment, and automated Terraform pipelines were not implemented.

---

# PowerShell Administration & Automation

Phase 10 introduced PowerShell scripts for Azure resource administration, inventory reporting, and configuration validation.

### Administrative Scripts

```text
Export-MTSResourceInventory.ps1
Get-MTSResourceInventory.ps1
Get-MTSStorageInventory.ps1
Test-MTSAzureEnvironment.ps1
```

The scripts support:

- Azure resource enumeration
- Resource-group reporting
- Resource type inventory
- Resource location reporting
- Governance tag inspection
- CSV inventory export
- Storage Account configuration reporting
- Azure environment validation

### Resource Inventory

```text
Azure Authentication
        |
        v
Get-AzResource
        |
        v
Select Resource Properties
        |
        v
Sort and Format
        |
        v
Administrative Inventory
```

### CSV Export

The inventory export workflow generates:

```text
MTS-Azure-Resource-Inventory.csv
```

The export includes resource details and selected governance tags.

### Environment Validation

The environment validation script provides repeatable administrative checks against selected Azure resources.

These scripts were developed for local administrative execution.

No Azure Automation Account, scheduled cloud runbook, Azure Function, or CI/CD pipeline was deployed as part of Phase 10.

---

# Cloud Troubleshooting

Phase 11 introduced three documented cloud troubleshooting incidents.

| Incident | Focus | Final Status |
|---|---|---|
| Storage Security Configuration | TLS configuration drift | Resolved |
| VM Network Connectivity | VM state and network dependency analysis | Resolved within tested scope |
| SSH Access Control | Temporary NSG deny rule | Resolved |

### Incident 01 — Storage Security Configuration

A controlled configuration change moved the Terraform Storage Account away from its expected TLS baseline.

The investigation used Azure PowerShell and Azure CLI to identify the configuration difference.

The minimum TLS version was restored to:

```text
TLS1_2
```

A dedicated PowerShell diagnostic confirmed:

```text
Provisioning State   PASS
Minimum TLS          PASS
HTTPS Only           PASS
```

### Incident 02 — VM Network Connectivity

The Linux workload VM was initially deallocated.

The investigation:

- Verified VM power state
- Started the virtual machine
- Confirmed provisioning state
- Identified the attached NIC
- Verified private IP configuration
- Traced the NIC to its subnet
- Identified the subnet-level NSG

The VM was returned to a running state during the exercise.

The investigation validated Azure resource state and network dependencies; it did not establish end-to-end SSH or application connectivity.

### Incident 03 — SSH Access Control

A temporary inbound NSG rule was introduced:

```text
TEMP-Deny-SSH-Inbound
```

The rule denied inbound TCP/22 traffic.

After investigating the NSG configuration, the temporary rule was removed.

Final validation confirmed:

```text
Temporary SSH Deny Rules: 0
```

The exercise demonstrated configuration-level SSH access troubleshooting and remediation.

### Phase 11 Cloud Health

The final diagnostic reported:

```text
Healthy:     9
Attention:   0
Failed:      0
```

Both diagnostic PowerShell scripts also passed syntax validation.

---

# Troubleshooting Methodology

The project retained selected troubleshooting evidence to demonstrate the investigation and remediation process.

The methodology used throughout the lab was:

```text
Identify
    |
    v
Establish Expected State
    |
    v
Collect Evidence
    |
    v
Isolate the Component
    |
    v
Determine Root Cause
    |
    v
Apply Targeted Remediation
    |
    v
Validate Actual State
    |
    v
Document Findings
```

Examples include:

- Azure Policy regional restrictions
- VM size availability
- SSH connectivity configuration
- Linux VM administration
- Azure RBAC authorization testing
- Storage configuration drift
- VM power-state troubleshooting
- Network dependency analysis
- NSG security-rule troubleshooting
- PowerShell diagnostic validation
- Terraform state and drift validation

The objective was to document both the expected configuration and the process used when actual behavior differed from expectations.

---

# Project Phases

| Phase | Description | Status |
|---:|---|:---:|
| 01 | [Planning & Architecture](Documents/01-Planning-Architecture/README.md) | Complete |
| 02 | [Azure Foundation](Documents/02-Azure-Foundation/README.md) | Complete |
| 03 | [Management Compute](Documents/03-Management-Compute/README.md) | Complete |
| 04 | [Compute](Documents/04-Compute/README.md) | Complete |
| 05 | [Identity & RBAC](Documents/05-Identity-RBAC/README.md) | Complete |
| 06 | [Storage](Documents/06-Storage/README.md) | Complete |
| 07 | [Security](Documents/07-Security/README.md) | Complete |
| 08 | [Monitoring & Logging](Documents/08-Monitoring-Logging/README.md) | Complete |
| 09 | [Infrastructure as Code](Documents/09-Infrastructure-as-Code/README.md) | Complete |
| 10 | [Administration & Automation](Documents/10-Administration-Automation/README.md) | Complete |
| 11 | [Cloud Troubleshooting](Documents/11-Cloud-Troubleshooting/README.md) | Complete |
| 12 | [Azure Environment Validation](Documents/12-Azure-Environment-Validation/README.md) | Complete |

Each phase includes implementation documentation and supporting evidence relevant to the work performed.

---

# Phase Summary

## Phase 01 — Planning & Architecture

Designed the Azure infrastructure architecture, resource naming conventions, network addressing plan, resource segmentation, and initial cost estimates.

Evaluated Azure for Students limitations and documented regional restrictions affecting deployment.

## Phase 02 — Azure Foundation

Established the Azure resource group structure, governance tags, monthly cost budget, action group, virtual network, three subnets, and subnet-level Network Security Groups.

Validated the foundation before deploying compute resources.

## Phase 03 — Management Compute

Deployed the Ubuntu Linux management VM, configured private networking, established restricted SSH administration, installed Azure CLI, and validated Azure management access.

Implemented automatic shutdown and cost controls.

## Phase 04 — Compute

Deployed additional Linux and Windows virtual machines within the server subnet.

Validated VM provisioning, networking, operating system configuration, and compute resource management.

## Phase 05 — Identity & RBAC

Implemented Azure RBAC and a user-assigned managed identity.

Configured resource-scoped Reader access and tested permitted and denied operations to demonstrate least-privilege authorization.

## Phase 06 — Storage

Deployed Azure Storage resources and blob containers.

Implemented storage authorization, configured diagnostic logging, and validated storage access and administrative operations.

## Phase 07 — Security

Introduced Azure Key Vault and security administration workflows.

Performed secret-management, authorization, security configuration, and diagnostic validation activities.

## Phase 08 — Monitoring & Logging

Configured Azure Monitor, Log Analytics, diagnostic settings, metric alerts, and action groups.

Validated monitoring behavior, including storage alert activation, resolution, and email notification.

## Phase 09 — Infrastructure as Code

Implemented Terraform using the AzureRM provider.

Provisioned a resource group, Storage Account, and private blob container.

Validated configuration and managed the deployment using local Terraform state.

## Phase 10 — Administration & Automation

Developed PowerShell administrative scripts for Azure resource inventory, CSV reporting, storage inspection, and environment validation.

Used Azure PowerShell to support repeatable cloud administration workflows.

## Phase 11 — Cloud Troubleshooting

Performed three controlled troubleshooting exercises involving Storage Account TLS configuration, VM network dependencies, and NSG SSH access controls.

Documented investigation, remediation, and validation results.

Developed reusable PowerShell health diagnostics.

## Phase 12 — Azure Environment Validation

Completed a structured audit of the deployed Azure environment.

Validated resource inventory, governance, networking, compute, identity, storage, security, monitoring, and Terraform state.

The final assessment recorded:

```text
Azure Resources:         27
Resource Groups:          5
Resource Types:          14

Cross-Service Checks:    10
Passed:                  10
Review Flags:             0
Failed:                   0

Terraform Drift:         None Detected
Virtual Machines:        3 Deallocated
```

The Azure infrastructure validation concluded successfully, with remaining governance and security-hardening findings documented.

---

# Technologies Used

![Microsoft Azure](https://img.shields.io/badge/Microsoft-Azure-0078D4)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-E95420)
![Windows](https://img.shields.io/badge/Windows-Server-0078D4)
![Terraform](https://img.shields.io/badge/HashiCorp-Terraform-844FBA)
![PowerShell](https://img.shields.io/badge/PowerShell-7-5391FE)
![Azure CLI](https://img.shields.io/badge/Azure-CLI-0078D4)

### Cloud Platform

- Microsoft Azure
- Azure for Students
- Azure Resource Manager
- Azure Portal
- Azure CLI
- Azure PowerShell

### Networking & Compute

- Azure Virtual Network
- Azure Subnets
- Network Security Groups
- Azure Network Interfaces
- Azure Public IP Addresses
- Azure Virtual Machines
- Ubuntu Linux
- Windows
- Azure Managed Disks
- Automatic VM Shutdown

### Identity & Security

- Microsoft Entra ID
- Azure RBAC
- User-Assigned Managed Identities
- Azure Key Vault
- Azure Storage Security
- TLS 1.2
- SSH Authentication

### Storage & Monitoring

- Azure Storage Accounts
- Azure Blob Storage
- Azure Monitor
- Log Analytics
- Azure Activity Logs
- Diagnostic Settings
- Azure Metric Alerts
- Azure Monitor Action Groups
- Kusto Query Language

### Infrastructure & Automation

- Terraform
- AzureRM Provider
- PowerShell 7
- Git
- GitHub
- CSV Reporting

---

# Repository Structure

```text
MTS-Azure-Cloud-Infrastructure-Lab/
|
|-- README.md
|
|-- Architecture/
|   `-- 01-Planning-Architecture/
|       `-- MTS-Azure-Planned-Architecture.PNG
|
|-- Documents/
|   |-- 01-Planning-Architecture/
|   |-- 02-Azure-Foundation/
|   |-- 03-Management-Compute/
|   |-- 04-Compute/
|   |-- 05-Identity-RBAC/
|   |-- 06-Storage/
|   |-- 07-Security/
|   |-- 08-Monitoring-Logging/
|   |-- 09-Infrastructure-as-Code/
|   |   `-- terraform/
|   |-- 10-Administration-Automation/
|   |   `-- PowerShell/
|   |-- 11-Cloud-Troubleshooting/
|   |   |-- Incident-Reports/
|   |   `-- PowerShell/
|   `-- 12-Azure-Environment-Validation/
|
|-- Screenshots/
|   |-- 01-Planning-Architecture/
|   |-- 02-Azure-Foundation/
|   |-- 03-Management-Compute/
|   |-- 04-Compute/
|   |-- 05-Identity-RBAC/
|   |-- 06-Storage/
|   |-- 07-Security/
|   |-- 08-Monitoring-Logging/
|   |-- 09-Infrastructure-as-Code/
|   |-- 10-Administration-Automation/
|   |-- 11-Cloud-Troubleshooting/
|   `-- 12-Azure-Environment-Validation/
|
`-- Troubleshooting/
    `-- 03-Management-Compute/
```

The repository is organized by phase to separate technical documentation, screenshots, source code, and troubleshooting evidence.

Terraform and PowerShell source files are maintained within their respective phase directories.

Local Terraform state files, credentials, and other sensitive working artifacts are excluded from the public repository.

---

# Documentation Approach

The repository contains implementation documentation, configuration evidence, validation results, and selected troubleshooting records.

Each phase documents the relevant work through a combination of:

- Technical objectives
- Infrastructure configuration
- Administrative procedures
- Commands and scripts
- Screenshots
- Validation results
- Troubleshooting findings
- Security considerations
- Operational lessons

The documentation distinguishes between:

```text
Planned Architecture
        |
        v
Deployed Infrastructure
        |
        v
Configured Services
        |
        v
Validated Behavior
        |
        v
Documented Findings
        |
        v
Final Environment State
```

The original planning diagram is retained as a historical design artifact.

It should not be interpreted as a complete representation of the final deployed architecture, which evolved during implementation.

Selected troubleshooting incidents are retained to demonstrate technical investigation and post-remediation verification.

---

# Final Validation

Phase 12 performed the final Azure environment assessment.

### Infrastructure Inventory

```text
Resource Groups:          5
Azure Resources:         27
Unique Resource Types:   14

Virtual Machines:         3
Managed Disks:            3
Network Interfaces:       3
Virtual Networks:         1
Network Security Groups:  3
Storage Accounts:         2
```

### Operational State

```text
Virtual Machines Running:      0
Virtual Machines Deallocated:  3

Automatic Shutdown Schedules:  3
```

### Security Baseline

```text
Storage TLS 1.2:          2/2 PASS
Storage HTTPS Only:       2/2 PASS

Temporary SSH Deny Rules: 0
```

### Terraform Validation

```text
terraform validate:
Success! The configuration is valid.

terraform plan:
No changes. Your infrastructure matches the configuration.
```

### Cross-Service Validation

```text
Azure Context              PASS
Resource Groups            PASS
Core Virtual Network       PASS
NSG and SSH Cleanup        PASS
Virtual Machines           PASS
Storage TLS and HTTPS      PASS
Log Analytics              PASS
Metric Alerts              PASS
Managed Identity           PASS
Terraform Azure Resources  PASS
```

Final result:

```text
Total Checks:  10
Passed:        10
Review Flags:   0
Failed:         0

PHASE 12 CROSS-SERVICE VALIDATION PASSED
```

### Outstanding Review Items

The final validation passed within its defined scope.

The audit also documented remaining governance, security, and cost considerations:

- Five resources without expected tags
- Public network access enabled on both Storage Accounts
- Account-level anonymous blob access capability enabled on Terraform storage
- Key Vault authorization mode requiring confirmation
- Continued allocation of a Standard public IPv4 address
- Ongoing managed disk and storage costs

These findings are retained as part of the final technical assessment.

---

# Project Outcome

The project began with Azure infrastructure planning and concluded with a deployed and validated cloud environment spanning networking, compute, identity, storage, security, monitoring, Infrastructure as Code, and administration.

The completed lab demonstrates the ability to:

- Design Azure cloud infrastructure
- Organize resource groups and governance tags
- Deploy and validate Azure Virtual Networks
- Configure subnet segmentation and Network Security Groups
- Deploy Linux and Windows virtual machines
- Implement restricted administrative SSH access
- Manage Azure VM lifecycle and costs
- Configure Azure RBAC and managed identities
- Test authorization boundaries
- Deploy Azure Storage and blob containers
- Review Storage Account security configurations
- Configure Azure Key Vault
- Implement Azure Monitor and Log Analytics
- Configure diagnostic settings and metric alerts
- Use Terraform to provision Azure resources
- Validate Terraform configuration and detect drift
- Develop PowerShell administration scripts
- Generate infrastructure inventory reports
- Troubleshoot VM, network, and storage issues
- Perform controlled security configuration testing
- Document incident investigations and remediation
- Conduct cross-service infrastructure validation
- Identify remaining security and governance improvements

The final environment provides a documented Azure infrastructure baseline for future technical projects.

---

# Future Expansion — Hybrid Networking & Identity

A separate future project may integrate the completed Azure environment with the existing on-premises Windows Server and Active Directory lab.

### Existing Environments

| Environment | Network |
|---|---|
| On-Premises Windows Server Lab | `10.10.10.0/24` |
| Azure Cloud Infrastructure Lab | `10.20.0.0/16` |

### Planned Areas of Investigation

- Hybrid network architecture
- Azure-to-on-premises connectivity
- Routing and DNS integration
- Connectivity cost analysis
- Network security boundaries
- Hybrid identity requirements
- Cross-environment administration
- Hybrid infrastructure monitoring
- Operational troubleshooting

These capabilities were not implemented during the completed 12-phase Azure project.

The current repository represents the completed Azure infrastructure foundation.

---

## Final Status

![Azure Lab Complete](https://img.shields.io/badge/MTS%20Azure%20Cloud%20Infrastructure%20Lab-COMPLETE-brightgreen)
![Phases](https://img.shields.io/badge/12%20of%2012%20Phases-COMPLETE-brightgreen)
![Validation](https://img.shields.io/badge/Cross--Service%20Validation-10%2F10%20PASS-brightgreen)
![Terraform](https://img.shields.io/badge/Terraform%20Drift-NONE%20DETECTED-success)

**PROJECT COMPLETE — AZURE INFRASTRUCTURE DEPLOYED, DOCUMENTED, AND VALIDATED**
