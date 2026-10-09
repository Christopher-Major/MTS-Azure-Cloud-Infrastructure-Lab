# Incident 02 — Azure VM Network Connectivity

## Incident Summary

A controlled network troubleshooting exercise was performed against the Azure Linux virtual machine `vm-mts-linux-01`.

The exercise focused on validating the VM's operational state, identifying its network interface and private IP configuration, tracing the workload through its Azure virtual network and subnet, identifying the applicable Network Security Group, and determining the correct security-control layer for subsequent connectivity troubleshooting.

---

## Affected Resource

| Property | Value |
|---|---|
| Virtual Machine | `vm-mts-linux-01` |
| Resource Group | `rg-mts-management-lab-01` |
| Operating System | Linux |
| Private IP | `10.20.20.4` |
| Virtual Network | `vnet-mts-lab-01` |
| Subnet | `snet-mts-server-01` |
| Subnet Prefix | `10.20.20.0/24` |
| Associated NSG | `nsg-mts-server-01` |

---

## Initial Condition

The Azure Linux VM was inspected as part of the Phase 11 cloud troubleshooting workflow.

The initial investigation showed that the virtual machine was in a deallocated state.

Because a powered-off workload cannot provide a valid basis for application-level or network-service troubleshooting, the VM's operational state had to be corrected before continuing with connectivity analysis.

---

## VM State Investigation

Azure PowerShell was used to inspect the virtual machine:

    Get-AzVM `
        -ResourceGroupName "rg-mts-management-lab-01" `
        -Name "vm-mts-linux-01" `
        -Status |
        Select-Object Name,
                      ResourceGroupName,
                      @{Name="PowerState";Expression={
                          ($_.Statuses | Where-Object Code -like "PowerState/*").DisplayStatus
                      }} |
        Format-Table -AutoSize

The VM was identified as deallocated.

---

## VM Recovery

The virtual machine was started using Azure PowerShell:

    Start-AzVM `
        -ResourceGroupName "rg-mts-management-lab-01" `
        -Name "vm-mts-linux-01"

Azure returned a successful start operation.

The VM state was then queried again.

Final power-state validation confirmed:

    Name              ResourceGroupName           PowerState
    ----              -----------------           ----------
    vm-mts-linux-01   rg-mts-management-lab-01    VM running

This eliminated VM power state as an active cause of subsequent connectivity problems.

---

## Network Interface Investigation

The virtual machine configuration was retrieved and its attached network interface was identified programmatically:

    $vm = Get-AzVM `
        -ResourceGroupName "rg-mts-management-lab-01" `
        -Name "vm-mts-linux-01"

    $nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
    $nicName = $nicId.Split("/")[-1]

    $nic = Get-AzNetworkInterface `
        -ResourceGroupName "rg-mts-management-lab-01" `
        -Name $nicName

The network interface configuration was then inspected:

    $nic |
        Select-Object Name,
                      @{Name="PrivateIP";Expression={$_.IpConfigurations[0].PrivateIpAddress}},
                      ProvisioningState |
        Format-Table -AutoSize

The investigation confirmed:

    Private IP:          10.20.20.4
    Provisioning State:  Succeeded

The network interface itself did not contain a directly associated Network Security Group.

---

## Subnet Investigation

Because no NSG was directly associated with the NIC, the investigation continued upstream to the subnet.

The subnet ID was extracted from the NIC IP configuration:

    $subnetId = $nic.IpConfigurations[0].Subnet.Id
    $subnetName = $subnetId.Split("/")[-1]

The Azure virtual network was then retrieved:

    $vnet = Get-AzVirtualNetwork `
        -ResourceGroupName "rg-mts-core-lab-01" `
        -Name "vnet-mts-lab-01"

The server subnet and its NSG association were inspected:

    $vnet.Subnets |
        Where-Object Name -eq $subnetName |
        Select-Object Name,
                      AddressPrefix,
                      @{Name="Subnet-NSG";Expression={
                          if ($_.NetworkSecurityGroup) {
                              $_.NetworkSecurityGroup.Id.Split("/")[-1]
                          }
                          else {
                              "None"
                          }
                      }} |
        Format-Table -AutoSize

The investigation confirmed:

    Subnet:      snet-mts-server-01
    Prefix:      10.20.20.0/24
    Subnet NSG:  nsg-mts-server-01

---

## Network Path Analysis

The investigation established the following Azure network relationship:

    vm-mts-linux-01
            |
            v
    Azure Network Interface
            |
            v
    Private IP: 10.20.20.4
            |
            v
    snet-mts-server-01
    10.20.20.0/24
            |
            v
    nsg-mts-server-01

This demonstrated that network security policy affecting the VM was being applied at the subnet level rather than directly to the VM's network interface.

---

## Root Cause Analysis

The initial VM deallocated state represented an operational condition that had to be eliminated before meaningful network troubleshooting could continue.

After starting the VM:

- VM provisioning was successful.
- VM power state was `VM running`.
- NIC provisioning was successful.
- Private IP `10.20.20.4` was present.
- The NIC was associated with the expected server subnet.
- The server subnet was associated with `nsg-mts-server-01`.

No Azure provisioning failure was identified within the VM, NIC, virtual network, or subnet.

The investigation therefore narrowed subsequent connectivity troubleshooting to the network security policy enforced through `nsg-mts-server-01`.

---

## Validation

The following components were validated:

| Component | Expected State | Result |
|---|---|---|
| VM | Running | Validated |
| VM Provisioning | Succeeded | Validated |
| NIC Provisioning | Succeeded | Validated |
| Private IP | `10.20.20.4` | Validated |
| Virtual Network | `vnet-mts-lab-01` | Validated |
| Server Subnet | `snet-mts-server-01` | Validated |
| Subnet Prefix | `10.20.20.0/24` | Validated |
| Associated NSG | `nsg-mts-server-01` | Validated |

The Phase 11 cloud health validation subsequently reported the VM and network interface as healthy.

---

## Resolution

**Status: RESOLVED**

The virtual machine was returned to a running state and the Azure network path was successfully mapped and validated.

No provisioning failure was identified within the VM, NIC, virtual network, or subnet.

The investigation successfully identified the subnet-level Network Security Group as the appropriate security-control layer for subsequent SSH access troubleshooting.

---

## Operational Lessons

This incident reinforced a layered approach to Azure network troubleshooting:

1. Verify that the workload is actually running.
2. Confirm Azure provisioning state.
3. Identify the VM's attached network interface.
4. Validate private IP configuration.
5. Trace the NIC to its associated subnet.
6. Validate the virtual network and subnet address range.
7. Determine whether security controls exist at the NIC or subnet level.
8. Identify the applicable Network Security Group before changing security rules.
9. Validate resource health after operational changes.

The exercise demonstrated why cloud troubleshooting should begin with workload state and dependency discovery rather than immediately modifying network security controls.

This approach reduces unnecessary configuration changes and provides a clearer path toward identifying the actual layer responsible for a connectivity problem.

---

## Skills Demonstrated

- Azure virtual machine administration
- Azure PowerShell
- VM state troubleshooting
- Azure NIC discovery
- Private IP validation
- Azure virtual network analysis
- Subnet discovery
- NSG association analysis
- Cloud dependency mapping
- Layered network troubleshooting
- Root-cause isolation
- Post-recovery validation

---

## Final Incident Status

**RESOLVED — VM operational state and Azure network path validated.**
