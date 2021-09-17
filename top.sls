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
    - common.resolv
    - common.kernel
    - common.datetime
    - common.systemd
    - network
#    - telegraf
    - openssh
    - borg
    - borg.borgmatic

# physical Servers
  'roles:vmhost':
    - match: pillar
    - wireguard
    - kvm
    - network.hardware-offloading
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

  'resolver*.ffrn.de':
    - nftables
    - network.conntrack
    - dehydrated
    - knot-resolver
    - knot-resolver.nftables

  'v6upstream.ffrn.de':
    - network.sysctl
    - knot-resolver
    - radvd

  'tools*.ffrn.de':
    - telegraf
    - docker.compose
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
    - docker.compose
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
    - nginx
    - dehydrated
    - docker

  'master.ffrn.de':
    - salt.master
    - dehydrated
    - systemd.networkd.wg-ffrn-in

  'map.ffrn.de':
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
    - telegraf

  'unifi.ffrn.de':
    - nftables
    - nginx
    - dehydrated
    - nginx.nftables
    - unifi
    - mesh-announce

  'gw*.ffrn.de':
    - nftables
    - network.bridge
    - network.sysctl
    - network.conntrack
    - dhcpv4
    - fastd
    - mesh-announce
