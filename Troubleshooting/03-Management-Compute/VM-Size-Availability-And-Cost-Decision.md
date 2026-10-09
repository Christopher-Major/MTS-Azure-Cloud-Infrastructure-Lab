# VM Size Availability and Cost Decision

## Issue

The original Phase 03 architecture planned to deploy the management
virtual machine using a low-cost Azure B-series VM.

During deployment, the expected B1s/B2-series sizes were unavailable
under the Azure for Students subscription and tested deployment
configurations.

## Troubleshooting Performed

Availability was evaluated using:

- Windows 11 Pro
- Ubuntu Server 24.04 LTS
- Central US
- East US
- Multiple VM size filters

Changing the operating system image and testing another region did not
provide the expected B-series deployment option.

## Architecture Decision

The management VM was deployed using:

- Ubuntu Server 24.04 LTS - x64 Gen2
- Standard_D2s_v4
- 2 vCPU
- 8 GiB RAM
- Central US

Ubuntu Server was selected instead of Windows 11 because it provided
the required cloud administration capabilities while substantially
reducing the estimated compute cost for the same available VM size.

## Cost Mitigation

Because Standard_D2s_v4 exceeds the original compute requirement,
the following cost controls were implemented:

- Azure monthly budget
- Budget alert notifications
- VM auto-shutdown
- Manual VM deallocation after lab sessions
- Standard SSD storage
- VM started only when required

## Operational Standard

The VM must normally remain:

`Stopped (deallocated)`

when the lab is not actively being used.

This prevents idle VM compute charges while retaining the environment
for future lab phases.
