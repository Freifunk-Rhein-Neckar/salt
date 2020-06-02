---
base:
  '*':
    - apt
    - common.resolv
    - common.packages
    - common.datetime
    - salt.minion
    - network
    - telegraf

# physical Servers
  'elsenz.ffrn.de,altneckar.ffrn.de,itter.ffrn.de':
    - match: list
    - telegraf

  # 'v6upstream.ffrn.de':
  #   - telegraf

  'gw*.freifunk-rhein-neckar.de':
    - fastd
    - network.bridge
    - dhcpv4

  'resolver*.ffrn.de':
    - nftables
    - knot-resolver
    - knot-resolver.nftables

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
    # - nftables       # not working with docker somehow
    # - nginx.nftables # not working with docker somehow
    - nginx
    - knot
    - dehydrated
    - docker.compose
  
  'tickets.ffrn.de':
    - nftables
    - nginx
    - nginx.nftables
    - dehydrated

  'forum.ffrn.de':
    - nftables
    - nginx
    - nginx.nftables
    - dehydrated
    - docker

  'map.ffrn.de':
    - yanic
    - nginx
    - dehydrated

  'unifi.ffrn.de':
    - nginx
    - dehydrated

  'netbox.ffrn.de':
    - nginx
    - dehydrated

  # 'test1.ffrn.de':
    # - nginx
    # - www.website
    # - telegraf
