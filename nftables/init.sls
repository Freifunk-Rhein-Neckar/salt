---
/etc/nftables.d:
  file.directory:
    - user: root
    - group: root

/etc/nftables.d/.keep:
  file.absent: []

nftables:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True

include:
  - nftables.stateful
