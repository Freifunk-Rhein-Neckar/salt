---
base:
  '*':
    - apt
    - common.resolv
    - common.packages
    - common.kernel
    - common.datetime
    - salt.minion
    - network
    - telegraf
    - openssh
    - mosh
{% if grains['virtual'] != 'LXC' %}
    - chrony
{% endif %}

# physical Servers
  'elsenz.ffrn.de,altneckar.ffrn.de,itter.ffrn.de':
    - match: list
    - telegraf
    - wireguard
    - telegraf.inputs.smart

  'resolver*.ffrn.de':
    - nftables
    - network.conntrack
    - dehydrated
    - knot-resolver
    - knot-resolver.nftables

  'v6upstream.ffrn.de':
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
    - network.batman-adv
    - yanic
    - nginx
    - dehydrated
    - meshviewer

  'meet.ffrn.de':
    - nftables
    - nginx.nftables
    - nginx
    - dehydrated
    - jitsi-meet

  'unifi.ffrn.de':
    - nginx
    - dehydrated

  'gw*.ffrn.de':
    - nftables
    - network.bridge
    - network.sysctl
    - network.conntrack
    - network.batman-adv
    - network.domains
    - dhcpv4
    - fastd
    - mesh-announce

  'test1.ffrn.de':
    - nftables
    # - network.bridge
    # - network.sysctl
    # - network.batman-adv
    # - network.domains
    # - dhcpv4
    # - fastd

    # - yanic
    # - nginx
    # - dehydrated
    # - meshviewer


    # - dhcpv4
    # - nginx
    # - www.website
    # - telegraf
