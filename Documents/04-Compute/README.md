
# Phase 4 — Compute

## Overview

Phase 4 expands the Major Technology Services (MTS) Azure Cloud Infrastructure Lab by deploying Windows Server and Linux virtual machines into the server subnet.

The existing Ubuntu management VM from Phase 3 provides the administrative entry point. Connectivity to the new workloads is tested through private Azure Virtual Network addresses rather than direct public access to the servers.

This phase covers VM deployment, network configuration, private SSH authentication, Windows RDP port validation, Network Security Group (NSG) review, credential cleanup, and cost management.

---

## Existing Infrastructure

Phase 4 builds on the resource groups, virtual network, and management VM established during earlier phases.

| Resource | Configuration |
|---|---|
| Subscription | Azure for Students |
| Region | Central US |
| Core Resource Group | `rg-mts-core-lab-01` |
| Management Resource Group | `rg-mts-management-lab-01` |
| Virtual Network | `vnet-mts-lab-01` |
| Address Space | `10.20.0.0/16` |
| Management Subnet | `10.20.10.0/24` |
| Server Subnet | `10.20.20.0/24` |
| Management NSG | `nsg-mts-management-01` |
| Server NSG | `nsg-mts-server-01` |

The management VM, `vm-mts-admin-01`, was deployed and configured in Phase 3. Phase 4 introduces two additional server workloads.

### Network Baseline

![Network Baseline](../../Screenshots/04-Compute/01-Network-Baseline.PNG)

The server subnet provides a dedicated network segment for Windows and Linux workloads.

---

## Compute Architecture

The environment uses three virtual machines.

| Virtual Machine | Operating System | Private IP | Role |
|---|---|---|---|
| `vm-mts-admin-01` | Ubuntu Server | `10.20.10.4` | Existing management VM |
| `vm-mts-linux-01` | Ubuntu Server | `10.20.20.4` | Linux server |
| `vm-mts-win-01` | Windows Server | `10.20.20.5` | Windows server |

The intended administrative path is:

```text
Administrative Workstation
          |
          | SSH / TCP 22
          | Restricted source IP
          |
          v
vm-mts-admin-01
10.20.10.4
Management Subnet
          |
          | Private Azure VNet
          |
          +-------------------------+
          |                         |
          v                         v
vm-mts-linux-01              vm-mts-win-01
10.20.20.4                   10.20.20.5
SSH / TCP 22                 RDP / TCP 3389
          |                         |
          +------------+------------+
                       |
                Server Subnet
                10.20.20.0/24
```

The Linux and Windows workloads do not require individual public IP addresses for the private connectivity tests performed in this phase.

---

## Linux VM Deployment

An Ubuntu Server VM was deployed into the existing server subnet.

### VM Size Selection

The available Linux VM sizes were reviewed before deployment.

![Linux VM Size Selection](../../Screenshots/04-Compute/02-Linux-VM-Size-Selection.PNG)

The VM was configured with an operating-system disk suitable for the lab workload.

### Disk Configuration

![Linux VM Disk Configuration](../../Screenshots/04-Compute/03-Linux-VM-Disk-Configuration.PNG)

### Network Configuration

The Linux VM was connected to:

```text
Virtual Network: vnet-mts-lab-01
Subnet:          snet-mts-server-01
Private IP:      10.20.20.4
Subnet NSG:      nsg-mts-server-01
```

![Linux VM Networking](../../Screenshots/04-Compute/04-Linux-VM-Networking.PNG)

The existing server subnet NSG provides network filtering for the workload.

### Resource Tags

The standard MTS tagging convention was applied.

![Linux VM Tags](../../Screenshots/04-Compute/05-Linux-VM-Tags.PNG)

### Deployment Validation

The Linux VM configuration passed pre-deployment validation.

![Linux VM Validation](../../Screenshots/04-Compute/06-Linux-VM-Validation-Passed.PNG)

The deployment completed successfully.

![Linux VM Deployment](../../Screenshots/04-Compute/07-Linux-VM-Deployment.PNG)

---

## Windows VM Deployment

A Windows Server VM was deployed into the same server subnet to support Windows administration and private network testing.

### VM Size Selection

The Windows VM size was reviewed against the available subscription options.

![Windows VM Size Selection](../../Screenshots/04-Compute/08-Windows-VM-Size-Selection.PNG)

### Disk Configuration

![Windows VM Disk Configuration](../../Screenshots/04-Compute/09-Windows-VM-Disk-Configuration.PNG)

### Network Configuration

The Windows VM was connected to:

```text
Virtual Network: vnet-mts-lab-01
Subnet:          snet-mts-server-01
Private IP:      10.20.20.5
Subnet NSG:      nsg-mts-server-01
```

![Windows VM Networking](../../Screenshots/04-Compute/10-Windows-VM-Networking.PNG)

### Resource Tags

![Windows VM Tags](../../Screenshots/04-Compute/11-Windows-VM-Tags.PNG)

### Deployment Validation

The Windows VM configuration passed pre-deployment validation.

![Windows VM Validation](../../Screenshots/04-Compute/12-Windows-VM-Validation-Passed.PNG)

The deployment completed successfully.

![Windows VM Deployment](../../Screenshots/04-Compute/13-Windows-VM-Deployment.PNG)

---

## Compute Resource Validation

After deployment, the compute resources were reviewed through the Azure portal.

### Compute Inventory

![Compute Inventory](../../Screenshots/04-Compute/14-Compute-Inventory.PNG)

### Server Subnet Placement

![Server Subnet Compute Placement](../../Screenshots/04-Compute/15-Server-Subnet-Compute-Placement.PNG)

The Linux and Windows VMs were placed in the server subnet, while the existing management VM remained in the management subnet.

### Management Resource Inventory

![Management Resource Inventory](../../Screenshots/04-Compute/16-Management-Resource-Inventory.PNG)

The resource inventory was reviewed to confirm the expected compute and supporting resources.

### Automatic Shutdown

VM auto-shutdown settings were reviewed as part of the lab's cost-control strategy.

![Compute Auto Shutdown](../../Screenshots/04-Compute/17-Compute-Auto-Shutdown.PNG)

### Cost Control Review

![Phase 4 Cost Control](../../Screenshots/04-Compute/18-Phase-04-Cost-Control.PNG)

The initial cost review established a baseline before the final operational tests.

### Portal Validation

The deployed compute environment was reviewed in the Azure portal.

![Compute Portal Validation](../../Screenshots/04-Compute/19-Compute-Portal-Validation.PNG)

### Network Validation

![Portal Network Validation](../../Screenshots/04-Compute/20-Portal-Network-Validation.PNG)

These checks confirmed the deployed compute resources and their network placement before private connectivity testing.

---

## Management NSG Configuration

External SSH access to the management VM was controlled by the existing management NSG.

| Setting | Configuration |
|---|---|
| NSG | `nsg-mts-management-01` |
| Rule | `Allow-SSH-Admin` |
| Priority | `100` |
| Direction | Inbound |
| Protocol | TCP |
| Destination Port | `22` |
| Source | Approved administrative public IP |
| Action | Allow |

![Management NSG SSH Rule](../../Screenshots/04-Compute/21-Management-NSG-SSH-Rule.PNG)

The rule permits SSH access from the approved administrative source rather than allowing unrestricted Internet access.

This configuration was established during Phase 3 and remained in use for Phase 4 testing.

---

## Compute Runtime Validation

All three virtual machines were started for connectivity testing.

![Compute VMs Running](../../Screenshots/04-Compute/22-Compute-VMs-Running.PNG)

The expected private addresses were:

```text
vm-mts-admin-01    10.20.10.4
vm-mts-linux-01    10.20.20.4
vm-mts-win-01      10.20.20.5
```

The server workloads were accessed through the existing management tier.

---

## Management VM Access

SSH connectivity was established from the administrative workstation to `vm-mts-admin-01`.

After authentication, the management VM was identified using:

```bash
hostname
hostname -I
```

The results confirmed:

```text
Hostname:   vm-mts-admin-01
Private IP: 10.20.10.4
```

![Admin VM SSH Connection](../../Screenshots/04-Compute/24-Admin-VM-SSH-Connection.PNG)

### Network Configuration

The management VM's interface and routing information were reviewed.

```bash
ip addr show
ip route
```

The VM reported:

```text
Private Address: 10.20.10.4/24
Default Gateway: 10.20.10.1
```

![Admin VM Network Identity](../../Screenshots/04-Compute/25-Admin-VM-Network-Identity.PNG)

This confirmed that the administrative system was operating within the expected management subnet.

---

## Linux Private Connectivity

Connectivity from the management VM to the Linux server was tested using its private IP address.

```text
Destination: 10.20.20.4
```

### ICMP Test

```bash
ping -c 4 10.20.20.4
```

Result:

```text
4 packets transmitted
4 received
0% packet loss
```

### SSH Port Test

```bash
nc -zv 10.20.20.4 22
```

Result:

```text
Connection to 10.20.20.4 22 port [tcp/ssh] succeeded!
```

![Admin to Linux Private Connectivity](../../Screenshots/04-Compute/26-Admin-to-Linux-Private-Connectivity.PNG)

The tests confirmed private network reachability and SSH service availability between the management and server subnets.

---

## Windows Private Connectivity

Connectivity from the management VM to the Windows server was tested using:

```text
Destination: 10.20.20.5
```

### ICMP Test

```bash
ping -c 4 10.20.20.5
```

Result:

```text
4 packets transmitted
0 received
100% packet loss
```

The Windows VM did not respond to ICMP echo requests.

### RDP Port Test

```bash
nc -zv 10.20.20.5 3389
```

The TCP connection succeeded.

![Admin to Windows Private Connectivity](../../Screenshots/04-Compute/27-Admin-to-Windows-Private-Connectivity.PNG)

This confirmed that TCP/3389 was reachable over the private Azure network despite the lack of an ICMP response.

The test established RDP port reachability. It did not independently verify an interactive Remote Desktop login.

---

## Private SSH Authentication

Authenticated SSH access to the Linux server was tested from the management VM.

### SSH Key Preparation

The Linux server's private key was temporarily placed on the management VM for testing.

File permissions were restricted:

```bash
chmod 600 ~/vm-mts-linux-01-key.pem
```

The permissions were verified using:

```bash
ls -l ~/vm-mts-linux-01-key.pem
```

Result:

```text
-rw-------
```

![Linux SSH Key Permissions](../../Screenshots/04-Compute/28-Linux-SSH-Key-Permissions.PNG)

### Linux SSH Connection

The management VM connected to the Linux server using its private address.

```bash
ssh -i ~/vm-mts-linux-01-key.pem azureadmin@10.20.20.4
```

After authentication, the remote system was validated using:

```bash
hostname
hostname -I
whoami
```

Results:

```text
Hostname:   vm-mts-linux-01
Private IP: 10.20.20.4
User:       azureadmin
```

![Private SSH Linux Validation](../../Screenshots/04-Compute/29-Private-SSH-Linux-Validation.PNG)

This confirmed authenticated SSH administration of the Linux workload entirely through private Azure networking.

---

## Linux Network and Service Validation

While connected to the Linux server, additional network and service checks were performed.

```bash
ip addr
ip route
ss -tln
```

The system reported the expected private address:

```text
10.20.20.4/24
```

The routing table was reviewed, and the socket listing confirmed that SSH was listening on TCP port `22`.

![Linux Network Service Validation](../../Screenshots/04-Compute/30-Linux-Network-Service-Validation.PNG)

The tests verified the Linux VM's private addressing, routing configuration, and SSH listener.

---

## Windows RDP Service Validation

A separate TCP connectivity check was performed against the Windows VM.

```text
Destination: 10.20.20.5
Port:        TCP/3389
```

The test confirmed that the RDP port was reachable from the management VM.

![Windows Private RDP Port Validation](../../Screenshots/04-Compute/31-Windows-Private-RDP-Port-Validation.PNG)

The successful TCP test was sufficient to establish network-level reachability to the Windows RDP service port.

Interactive RDP authentication was not part of the documented validation.

---

## Server NSG Validation

The server subnet was associated with:

```text
nsg-mts-server-01
```

The NSG configuration showed:

| Setting | Result |
|---|---|
| Associated Subnets | 1 |
| Associated Network Interfaces | 0 |
| Custom Inbound Rules | None |

![Server NSG Inbound Rules](../../Screenshots/04-Compute/32-Server-NSG-Inbound-Rules.PNG)

Private communication between the management and server workloads was permitted through Azure's default `AllowVnetInBound` rule.

No custom server-tier inbound rules were required for the connectivity tests performed during this phase.

The NSG association provides a security enforcement point, but the default VNet inbound rule does not isolate the server subnet from other permitted traffic within the virtual network.

More restrictive workload-specific rules can be introduced if later requirements call for them.

---

## SSH Credential Cleanup

The Linux server's private SSH key was required temporarily on the management VM for authentication testing.

After the test, the key was removed:

```bash
rm ~/vm-mts-linux-01-key.pem
```

The home directory was reviewed to confirm the temporary file was no longer present.

```bash
ls -la ~
```

![Admin Key Cleanup](../../Screenshots/04-Compute/33-Admin-Key-Cleanup.PNG)

Removing the temporary key reduced unnecessary retention of private authentication material on the management VM.

---

## VM Deallocation

After connectivity and service validation, all three virtual machines were stopped and deallocated.

| Virtual Machine | Final State |
|---|---|
| `vm-mts-admin-01` | Stopped (deallocated) |
| `vm-mts-linux-01` | Stopped (deallocated) |
| `vm-mts-win-01` | Stopped (deallocated) |

![Phase 4 VMs Deallocated](../../Screenshots/04-Compute/34-Phase-04-VMs-Deallocated.PNG)

Deallocation stops the associated VM compute charges.

Managed disks, public IP resources, and other retained Azure services may continue to incur charges while the VMs are deallocated.

---

## Cost Validation

Azure Cost Management was reviewed after Phase 4 testing.

At the time of the final review:

| Item | Recorded Value |
|---|---|
| Accumulated Cost | Approximately $0.47 |
| Running VMs | 0 |
| Deallocated VMs | 3 |

The cost analysis showed consumption associated with virtual machines, storage, networking, bandwidth, and monitoring.

![Phase 4 Final Cost Check](../../Screenshots/04-Compute/35-Phase-04-Final-Cost-Check.PNG)

The reported amount represents a point-in-time billing snapshot.

Additional charges may appear after reporting delays or from retained resources.

---

## Phase 4 Verification

Phase 4 established and validated the compute environment:

- Linux server VM deployed into the server subnet
- Windows server VM deployed into the server subnet
- Existing management VM reused for administration
- All three VM private addresses verified
- Management NSG restricted SSH rule reviewed
- Management VM SSH access validated
- Management VM routing and interface configuration checked
- Linux server ICMP connectivity successful
- Linux server TCP/22 reachable
- Linux SSH authentication successful over private networking
- Linux network configuration and SSH listener validated
- Windows TCP/3389 reachable over private networking
- Windows ICMP test recorded without a response
- Server NSG association and default inbound rules reviewed
- Temporary Linux SSH private key removed
- All three VMs deallocated after testing
- Azure Cost Management reviewed

The Windows RDP test confirmed TCP port reachability rather than a completed interactive login.

The server subnet retained Azure's default VNet inbound permissions during this phase.

**Phase 4 Status: Complete**

---

## Next Phase

**Phase 5 — Identity & RBAC**

Phase 5 introduces Azure identity and authorization administration.

The next phase will review Microsoft Entra ID access boundaries, Azure role assignments, resource-group permissions, and managed identities.

Identity and authorization controls will be validated against the resource groups and workloads established during the earlier phases.
