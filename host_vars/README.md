
# Configuration of Host Variables

## YAML Syntax Primer

- Do not use tabs, only spaces
- Quotes for the values are needed rarely (e.g. if the value is a description containing a double colon)

### YAML Data Types

#### Key-Value Pair
`vlans: 1100`

#### List (or "Sequence")
`vlans: [1100, 1200, 1300]`

or, alternatively:
```
members:
  - ge-0/0/1
  - ge-0/0/2
  - ge-0/0/3
```

#### Dictionary (or "Hash")
```
ge-0/0/0:
  mode: trunk
  vlans: [1100, 1200, 1300]
```

## Configuration parameters

All device-specific variables need to be in `host_vars` and all variables concerning multiple devices need to be in `group_vars`.

The below list of parameters is implemented at this time and can easily be extended via the templates.

Conforming to the Junos OS configuration, statements that are not needed can and should be omitted. If you need to disable an interface, configure `disable: true` , if it needs to be enabled, just omit the statement instead of configuring `disable: false`, because then the Junos OS default values apply.


### Interface Description

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    desc: value
```
#### Example
```
interfaces:
  ge-0/0/1:
    desc: host1.loc1
```

### Interface VLAN

#### Syntax
Note: The template is built in a way that the `vlans` key can handle a list (multiple VLANs) as well as a string (single VLAN).
```
interfaces:
  ge-fpc/pic/port:
    vlans: all|VLAN-ID
    # or, for multiple VLANs:
    vlans: [VLAN-ID, VLAN-ID]
    vlan_groups:
      - group_vlangroup  # writes a group of VLANs from group_vars/group to the interface
```
#### Examples
```
interfaces:
  ge-0/0/1:
    desc: host1.loc1
    vlans: 1234
```
```
interfaces:
  ge-0/1/0:
    desc: trunk to switch1.loc1
    vlans: all
```
```
interfaces:
  ge-0/0/2:
    desc: trunk to host2.loc1
    vlans: [1234, 2345]
```
```
interfaces:
  ge-0/0/3:
    desc: host3.loc1
    vlan_groups:
      - group_loc1
```

### Interface Mode + Native VLAN

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    mode: trunk|access
    native: VLAN-ID
```
#### Examples
```
interfaces:
  ge-0/0/1:
    mode: access
```
```
interfaces:
  ge-0/0/2:
    mode: trunk
    native: 1234
```
### Interface Range

#### Syntax
Note: The template is built in a way that the `member_ranges` and `members` keys can handle a list as well as a string.
```
if_ranges:
  rangename:
    member_ranges: ge-fpc/pic/port to ge-fpc/pic/port
    # or, for multiple ranges:
    member_ranges:
      - ge-fpc/pic/port to ge-fpc/pic/port
      - ge-fpc/pic/port to ge-fpc/pic/port
    members: ge-fpc/pic/port
    # or, for multiple members:
    members:
      - ge-fpc/pic/port
      - ge-fpc/pic/port
    ...other applicable parameters are the same as with physical interfaces
```
#### Example
```
if_ranges:
  switch-links:
    member_ranges:
      - ge-0/1/0 to ge-0/1/23
      - xe-0/1/0 to xe-0/1/23
    members: ge-0/0/47
    vlans: 1234
```

### Interface range for aggregated ethernet Interfaces

With `ae_ranges`, parameters for aggregated-ethernet interfaces can be grouped analogous to the standard interface ranges. Because logical interfaces are not supported by the Junos interface ranges, the parameters from `ae_ranges` are written to every single interface within the range when the configuration is build.

#### Syntax
```
ae_ranges:
  rangename:
    members: aeN
    # oder, bei mehreren Members:
    members:
      - aeN1
      - aeN2
    # other paramaters (e.g. VLAN) analogous to physical interfaces
```
#### Example
```
ae_ranges:
  switch-links:
    members:
      - ae0
      - ae1
    vlans: 1234
```

### Disable Interface

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
  disable: true
```
#### Example
```
interfaces:
  ge-0/0/1:
  disable: true
```

### Disable Spanning Tree Protocol on an Interface

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
  stp: disable
```
The interface will be disabled under `protocols { rstp/mstp }` and `bpdu drop` under `ethernet-switching-options` will be enabled.

#### Example
```
interfaces:
  ge-0/0/1:
  stp: disable
```

### Interface MTU

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
  mtu: value
```
#### Example
```
interfaces:
  ge-0/0/1:
  mtu: 1492
```

### Interface Speed, Duplex & Autonegotiation

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    etheroptions:
      no_autoneg: true
      duplex: full|half
      speed: value
```
#### Example
```
interfaces:
  ge-0/0/1:
    etheroptions:
      no_autoneg: true
      duplex: half
      speed: 100m
```

### LACP Link Aggregation Group (LAG)

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    etheroptions:
      lacp_interface: aeN
  aeN:
    speed_individual_links: 100m|1g|10g
    # other paramaters (e.g. VLAN) analogous to physical interfaces
```
The number of ae interfaces under `chassis { aggregated-devices }` will be set automatically.

#### Example
```
interfaces:
  xe-0/1/0:
    etheroptions:
      lacp_interface: ae0
  xe-0/1/1:
    etheroptions:
      lacp_interface: ae0
  ae0:
    desc: switch3.loc5 aeX
    speed_individual_links: 10g
    vlans: all
```

### IP Addresses

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    ipv4:
      - addr: ip-address/mask
    ipv6:
      - addr: ip-address/mask
```
#### Example
```
interfaces:
  ge-0/0/1:
    ipv4:
      - addr: 10.20.30.40/24
    ipv6:
      - addr: 1a02:f34::5:67:8/112
```

### Multiple IP addresses on one interface

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    ipv4:
      - addr: ip-address/mask
        type: primary|preferred|[primary,preferred]
      - addr: ip-address/mask
```
#### Example
```
interfaces:
  ge-0/0/1:
    ipv4:
      - addr: 10.20.30.40/24
        type: primary
      - addr: 20.30.40.50/32
```

### Static ARP entry

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    ipv4:
      - addr: ip-address/mask
        static_arp:
          ip-address: mac-address
```
#### Example
```
interfaces:
  ge-0/0/1:
    ipv4:
      - addr: 10.20.30.40/24
        static_arp:
          10.20.30.43: 00:0c:f6:e8:22:fd
```

### Interface unit (VLAN interface on a physical interface)

#### Syntax
```
interfaces:
  ge-fpc/pic/port:
    units:
      unit-number:
        # paramaters (e.g. description, ip address, ..) analogous to physical interfaces
```
The VLAN ID is set automatically by reference to the number of the interface unit.

#### Example
```
interfaces:
  ge-0/0/1:
    units:
      1234:
        desc: foo
        ipv4:
          - addr: 1.2.3.4/24
      2345:
        [...]
```

### VLAN Unit (Virtual L3 Interface)

#### Syntax
```
vlan_units:
  unit-number:
    # paramaters (e.g. description, ip address, ..) analogous to physical interfaces
```
The L3 interface within the respective vlan under `vlans {}` is set automatically.

#### Example
```
vlan_units:
  1234:
    desc: foo
    ipv4:
      - addr: 1.2.3.4/24
  2345:
    [...]
```

### VLANs (Group-based)

#### Syntax
```
# In group_vars/region.yml for rolling out VLANs to all devices within this region
vlan_groups:
  region_location:
    VLAN ID: VLAN Name
```
#### Example
```
vlan_groups:
  region1_location1:
    1234: VL1234_Mgmt
```

### VLANs (locally on a switch, e.g. for testing purposes)

#### Syntax
```
# In host_vars/<host>.yml
vlans_host:
  VLAN ID: VLAN Name
```
#### Example
```
vlans_host:
  1234: VL1234_Testing_local
```

### Virtual Chassis (VC)

#### Syntax
```
virtualchassis:
  members:
    member-number:
      role: routing-engine|line-card
      serial: ABC
```
The parameters `system { commit synchronize }` und `chassis { redundancy { graceful-switchover }}` will be set automatically.

#### Example
```
virtualchassis:
  members:
    0:
      role: routing-engine
      serial: AB1234567890
    1:
      role: routing-engine
      serial: BC2345678901
    2:
      role: line-card
      serial: CD3456789012
```
As long as no mastership priority is configured, both switches that are configured as routing-engine will have a default priority of 128, with the device first switched on being master.

### Disabling the Junos ELS Syntax

This is necessary for all older Juniper Switches like EX2200 or EX3300. Default is true.

#### Syntax
```
junos_els: false
```

### 802.1X (Port-based network access control / PNAC)

#### Syntax
```
dot1x: true
# Additionaly, there must be an interface range with the name "access-dot1x" and respective member interfaces.
```
#### Example
```
dot1x: true
if_ranges:
  access-dot1x:
    member_ranges: ge-0/0/0 to ge-0/0/23
```

### Group parameters for access switches / locations

Default gateway and VLANs are configured via the group_vars file of the respective location.

#### Syntax
```
# group_vars/region_location.yml
routing:
  v4_defaultgw: ip-address
  v6_defaultgw: ip-address
group:
  vlan_groups:
    - vlan-group-name
```
#### Example
```
# group_vars/region1_location1.yml
routing:
  v4_defaultgw: 10.32.17.1
  v6_defaultgw: 2a02:f28:f:3217::1
group:
  vlan_groups:
    - region1_loc-all
    - region1_loc1
```

### SNMP Location

#### Syntax
```
location: value
```
#### Example
```
location: Loc1.R02.R01
```

### Spanning Tree Bridge Priority

#### Syntax
```
mstp:
  bridge_prio: priority-value
```
#### Example
```
mstp:
  bridge_prio: 32k
```

### Power-over-Ethernet

By default, PoE is activated with dynamic power on all interfaces. However, some Junos OS versions have a PoE controller bug that requires static PoE configuration, because otherwise only a fraction of the total power capacity can be used.
For this workaround the total power capacity of a switch should be divided by the number of interfaces, and the rounded result be set as maximum value (e.g. 100 W / 12 access ports = 8,33 --> `interface_max_power: 8`)

#### Syntax
```
poe:
  static: true
  interface_max_power: value
```
#### Example
```
poe:
  static: true
  interface_max_power: 8
```

