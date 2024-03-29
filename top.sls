---
base:
  '*':
    - salt.minion
    - common.packages
    - iperf3
    - mosh
    - prometheus.exporter
    - openssh.authorized_keys
    - systemd.networkd.wg-ffrn-in
{% if grains['virtual'] != 'LXC' %}
    - chrony
{% endif %}

  'os:Debian':
    - match: grain
    - apt
    - common.kernel
    - common.datetime
    - common.systemd
    - network
#    - telegraf
    - openssh
    - borg
    - borg.borgmatic

  'osfinger:Debian-11':
    - match: grain
    - systemd.resolved

  'osfinger:Debian-10':
    - match: grain
    - common.resolv

  # physical Servers - `salt -I 'roles:vmhost' state.apply`
  'roles:vmhost':
    - match: pillar
    - wireguard
    - kvm
    - network.hardware-offloading
    - network.bridge
    - systemd.networkd
    - systemd.networkd.mainif
    - systemd.networkd.br-vm

  'roles:mesh_batman':
    - match: pillar
    - nftables
    - systemd.backports
    - systemd.networkd.wg-ffrn
    - systemd.networkd.br-mesh
    - systemd.networkd.vxlan
    - network.domains
    - batman_adv
    - mesh-announce
    - network.batman-adv

  'resolver*.ffrn.de':
    - systemd.networkd.mainif
    - nftables
    - network.conntrack
    - dehydrated
    - knot-resolver
    - knot-resolver.nftables

  'v6upstream.ffrn.de':
    - systemd.networkd.mainif
    - nginx.nftables
    - dehydrated
    - network.bridge
    - network.sysctl
    - network.conntrack
    - knot-resolver
    - knot-resolver.nftables
    - radvd

  'tools*.ffrn.de':
    - systemd.networkd.mainif
    {# - docker.compose #}
    - knot
    - dehydrated

  'tools-elsenz.ffrn.de':
    - www.website
    - knot.master
    - yanic.zonefile
    - ffrn-node-manager
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
    {# - docker
    - docker.compose.ng #}
    - wireguard
    - common.packages.apache2-utils
    - prometheus.blackbox-exporter

  'tickets.ffrn.de':
    - nftables
    - nginx
    - nginx.nftables
    - dehydrated

  'forum.ffrn.de':
    # - nftables       # not working with docker
    # - nginx.nftables # not working with docker
    - systemd.networkd.mainif
    - nginx
    - dehydrated
    {# - docker #}

  # the master is deployed with `salt-call --local state.apply` from itself. This leaves less chances for an unwanted change.
  'master.ffrn.de':
    - salt.master
    - dehydrated
    - systemd.networkd.wg-ffrn-in
    - systemd.networkd.mainif
    - kvm.virtinst

  'map*.ffrn.de':
    - yanic
    - nginx
    - nginx.nftables
    - dehydrated
    - meshviewer
    - prometheus.blackbox-exporter

  'meet.ffrn.de':
    - nftables
    - nginx.nftables
    - nginx
    - dehydrated
    - jitsi-meet
    - telegraf

  'unifi.ffrn.de':
    - systemd.networkd.mainif
    - nftables
    - nginx
    - dehydrated
    - nginx.nftables
    - unifi
    - mesh-announce

  'gw*.ffrn.de':
    - systemd.networkd.mainif
    - nginx.nftables
    - nftables
    - network.bridge
    - network.sysctl
    - network.conntrack
    - dhcpv4
    - fastd
    - mesh-announce
