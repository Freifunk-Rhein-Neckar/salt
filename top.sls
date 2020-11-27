---
base:
  '*':
    - apt
    - common.resolv
    - common.packages
    - common.kernel
    - common.datetime
    - common.systemd
    - salt.minion
    - network
    - telegraf
    - openssh
    - mosh
    - iperf3
{% if grains['virtual'] != 'LXC' %}
    - chrony
{% endif %}

# physical Servers
  'roles:vmhost':
    - match: pillar
    - telegraf
    - wireguard
    - kvm
    - telegraf.inputs.smart
    - systemd.networkd
    - systemd.networkd.mainif
    - systemd.networkd.br-vm

  'resolver*.ffrn.de':
    - nftables
    - systemd
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - network.domains
    - network.conntrack
    - dehydrated
    - knot-resolver
    - knot-resolver.nftables
    - batman_adv

  'v6upstream.ffrn.de':
    - nftables
    - knot-resolver
    - systemd
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - network.domains
    - radvd
    - batman_adv
    - mesh-announce

  'tools*.ffrn.de':
    - telegraf
    - docker.compose
    - knot
    - dehydrated

  'tools-elsenz.ffrn.de':
    - www.website
    - knot.master
    - yanic.zonefile
    # - nginx

  'tools-itter.ffrn.de':
    # - nftables
    # - knot.nftables
    # - nginx.nftables
    - nginx
    - www.firmware

  'stats.ffrn.de':
    # - nftables       # not working with docker
    # - nginx.nftables # not working with docker
    - nginx
    - knot
    - dehydrated
    - docker.compose
    - wireguard

  'tickets.ffrn.de':
    - nftables
    - nginx
    - nginx.nftables
    - dehydrated

  'forum.ffrn.de':
    # - nftables       # not working with docker
    # - nginx.nftables # not working with docker
    - nginx
    - dehydrated
    - docker

  'map.ffrn.de':
    - nftables
    - systemd
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - network.domains
    - yanic
    - nginx
    - nginx.nftables
    - dehydrated
    - meshviewer

  'meet.ffrn.de':
    - nftables
    - nginx.nftables
    - nginx
    - dehydrated
    - jitsi-meet

  'unifi.ffrn.de':
    - nftables
    - nginx
    - dehydrated
    - batman_adv
    - systemd
    - systemd.networkd.br-mesh
    - nginx.nftables
    - unifi
    - mesh-announce

  'gw*.ffrn.de':
    - nftables
    - systemd
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - network.bridge
    - network.sysctl
    - network.conntrack
    - batman_adv
    - network.domains
    - dhcpv4
    - fastd
    - mesh-announce

  'test*.ffrn.de':
    - nftables
    - systemd
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - batman_adv
    - network.bridge
    - network.sysctl
    - network.conntrack
    - network.domains
    - mesh-announce
