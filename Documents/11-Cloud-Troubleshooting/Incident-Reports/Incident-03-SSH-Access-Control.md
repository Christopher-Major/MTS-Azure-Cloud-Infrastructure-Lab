# Incident 03 — SSH Access Control

## Incident Summary

A controlled SSH access incident was created against the Azure Linux VM environment by introducing a temporary Network Security Group rule that explicitly denied inbound TCP port 22 traffic.

The purpose of the exercise was to simulate a cloud network security misconfiguration capable of preventing legitimate SSH administration, identify the blocking security control, remediate the configuration, and prove through post-remediation validation that the temporary rule had been completely removed.

---

## Affected Resources

| Property | Value |
|---|---|
| Virtual Machine | `vm-mts-linux-01` |
| VM Resource Group | `rg-mts-management-lab-01` |
| Private IP | `10.20.20.4` |
| Virtual Network | `vnet-mts-lab-01` |
| Server Subnet | `snet-mts-server-01` |
| Subnet Prefix | `10.20.20.0/24` |
| Network Security Group | `nsg-mts-server-01` |
| NSG Resource Group | `rg-mts-core-lab-01` |
| Affected Protocol | TCP |
| Affected Port | 22 / SSH |

---

## Baseline Investigation

The network path for `vm-mts-linux-01` was established before the controlled incident was introduced.

The investigation confirmed:

- `vm-mts-linux-01` was running.
- The VM used private IP `10.20.20.4`.
- The VM was connected to `snet-mts-server-01`.
- The server subnet used address prefix `10.20.20.0/24`.
- The subnet was associated with `nsg-mts-server-01`.

The NSG's default security rules were inspected:

    $nsg = Get-AzNetworkSecurityGroup `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "nsg-mts-server-01"

    $nsg.DefaultSecurityRules |
        Select-Object Name,
                      Priority,
                      Direction,
                      Access,
                      Protocol,
                      SourceAddressPrefix,
                      DestinationAddressPrefix,
                      DestinationPortRange |
        Sort-Object Priority |
        Format-Table -AutoSize

The baseline contained the standard Azure NSG default rules, including:

- `AllowVnetInBound`
- `AllowAzureLoadBalancerInBound`
- `DenyAllInBound`
- `AllowVnetOutBound`
- `AllowInternetOutBound`
- `DenyAllOutBound`

No custom security rules were initially present.

This established a known-good NSG baseline before introducing the controlled failure.

---

## Controlled Incident

A temporary custom security rule was added to `nsg-mts-server-01`:

    $nsg = Get-AzNetworkSecurityGroup `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "nsg-mts-server-01"

    $nsg | Add-AzNetworkSecurityRuleConfig `
        -Name "TEMP-Deny-SSH-Inbound" `
        -Description "Phase 11 controlled troubleshooting scenario" `
        -Access Deny `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority 100 `
        -SourceAddressPrefix "*" `
        -SourcePortRange "*" `
        -DestinationAddressPrefix "*" `
        -DestinationPortRange 22

    $nsg | Set-AzNetworkSecurityGroup

Azure successfully provisioned the modified Network Security Group.

The temporary rule intentionally created an explicit inbound deny condition for SSH traffic.

---

## Incident Verification

The NSG was queried specifically for security rules affecting destination port 22:

    (Get-AzNetworkSecurityGroup `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "nsg-mts-server-01").SecurityRules |
        Where-Object {
            $_.DestinationPortRange -eq "22" -or
            $_.DestinationPortRanges -contains "22"
        } |
        Select-Object Name,
                      Priority,
                      Direction,
                      Access,
                      Protocol,
                      SourceAddressPrefix,
                      DestinationPortRange |
        Sort-Object Priority |
        Format-Table -AutoSize

The investigation identified:

    Name                     Priority  Direction  Access  Protocol  SourceAddressPrefix  DestinationPortRange
    ----                     --------  ---------  ------  --------  -------------------  --------------------
    TEMP-Deny-SSH-Inbound    100       Inbound    Deny    Tcp       *                    22

This confirmed that the controlled SSH blocking condition was present.

---

## Root Cause

The simulated SSH access problem was isolated to the custom Network Security Group rule:

    TEMP-Deny-SSH-Inbound

The rule enforced:

    Direction:         Inbound
    Protocol:          TCP
    Destination Port:  22
    Access:            Deny
    Priority:          100

Because this was a custom inbound deny rule affecting TCP/22, it represented the security configuration responsible for the controlled SSH access failure.

The investigation successfully moved from workload state to NIC configuration, subnet association, NSG identification, and finally the specific security rule responsible for the incident.

---

## Remediation

The temporary SSH deny rule was removed from the Network Security Group:

    $nsg = Get-AzNetworkSecurityGroup `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "nsg-mts-server-01"

    Remove-AzNetworkSecurityRuleConfig `
        -Name "TEMP-Deny-SSH-Inbound" `
        -NetworkSecurityGroup $nsg

    $nsg | Set-AzNetworkSecurityGroup

Azure successfully applied the updated NSG configuration.

---

## Post-Remediation SSH Validation

The NSG was retrieved again after remediation:

    $nsg = Get-AzNetworkSecurityGroup `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "nsg-mts-server-01"

The custom security rules were searched for inbound deny rules affecting TCP port 22:

    $sshDeny = $nsg.SecurityRules |
        Where-Object {
            $_.Direction -eq "Inbound" -and
            $_.Access -eq "Deny" -and
            (
                $_.DestinationPortRange -eq "22" -or
                $_.DestinationPortRanges -contains "22"
            )
        }

The resulting security state was summarized:

    [PSCustomObject]@{
        NSG                  = $nsg.Name
        ProvisioningState    = $nsg.ProvisioningState
        CustomSSHDenyRules   = @($sshDeny).Count
        SSHBlockingCondition = if (@($sshDeny).Count -eq 0) { "CLEARED" } else { "PRESENT" }
    } | Format-List

Post-remediation validation confirmed:

    NSG                  : nsg-mts-server-01
    ProvisioningState    : Succeeded
    CustomSSHDenyRules   : 0
    SSHBlockingCondition : CLEARED

The custom rule was therefore confirmed absent rather than merely assumed removed.

---

## VM and Network Validation

The affected workload and network interface were also validated after remediation.

The environment confirmed:

    VM               : vm-mts-linux-01
    PowerState       : VM running
    PrivateIP        : 10.20.20.4
    NICState         : Succeeded
    AssociatedSubnet : snet-mts-server-01

This demonstrated that:

- The VM remained operational.
- The network interface remained successfully provisioned.
- The expected private IP remained assigned.
- The VM remained connected to the correct server subnet.
- The subnet remained protected by the expected NSG.
- The temporary SSH deny condition no longer existed.

---

## Final Environment Validation

The Phase 11 final environment validation included a specific check for the temporary SSH deny rule.

The final cloud health assessment reported the SSH cleanup condition as healthy:

    SSH Incident Cleanup    HEALTHY    Temporary deny rule removed

The complete Phase 11 validation reported:

    Component              Status     Details
    ---------              ------     -------
    Azure Context          HEALTHY    Azure for Students
    Linux VM               HEALTHY    vm-mts-linux-01 - VM running
    Network Interface      HEALTHY    vm-mts-linux-0138 - 10.20.20.4
    Core Virtual Network   HEALTHY    vnet-mts-lab-01
    Server Subnet          HEALTHY    snet-mts-server-01 - 10.20.20.0/24
    Server NSG             HEALTHY    nsg-mts-server-01
    SSH Incident Cleanup   HEALTHY    Temporary deny rule removed
    Terraform Storage      HEALTHY    stmtsterraformlab01 - TLS1_2
    Terraform Container    HEALTHY    terraform-lab

    Healthy   : 9
    Attention : 0
    Failed    : 0

    PHASE 11 VALIDATION PASSED

This provided final confirmation that the controlled incident had been remediated without leaving the environment in a degraded state.

---

## Resolution

**Status: RESOLVED**

The temporary SSH blocking rule was successfully identified and removed.

Post-remediation validation confirmed:

- NSG provisioning state was `Succeeded`.
- Custom SSH deny rule count was `0`.
- SSH blocking condition was `CLEARED`.
- VM remained in a running state.
- NIC remained successfully provisioned.
- Private IP remained `10.20.20.4`.
- Server subnet association remained intact.
- The final Phase 11 environment validation passed.
- No temporary troubleshooting security rule remained in the final lab configuration.

No additional remediation was required.

---

## Operational Lessons

This incident demonstrated several important Azure network security troubleshooting practices:

- Establish the existing NSG baseline before making changes.
- Verify workload health before investigating network security.
- Trace VM connectivity through the NIC, subnet, and associated NSG.
- Understand the difference between NIC-level and subnet-level NSG associations.
- Understand Azure NSG priority processing.
- Search specifically for rules affecting the impacted protocol and destination port.
- Differentiate Azure default NSG rules from custom security rules.
- Remove temporary troubleshooting rules after testing.
- Validate the resulting NSG configuration after remediation.
- Verify workload and network health after security-policy changes.
- Include temporary-rule cleanup in final environment health checks.

The exercise also demonstrated why a successful remediation command alone is insufficient.

The Azure environment was queried after remediation to prove that the blocking rule was actually absent and that the affected VM and network resources remained healthy.

---

## Skills Demonstrated

- Azure Network Security Groups
- Azure PowerShell
- Linux VM administration
- SSH troubleshooting
- TCP/22 access-control analysis
- NSG rule priority analysis
- VM-to-NIC dependency tracing
- NIC-to-subnet dependency tracing
- Subnet-level security analysis
- Controlled fault injection
- Root-cause analysis
- Security-rule remediation
- Post-remediation validation
- Cloud incident response

---

## Final Incident Status

**RESOLVED — SSH blocking condition removed and environment health validated.**
