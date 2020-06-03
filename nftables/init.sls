---
/etc/nftables.d:
  file.directory:
    - user: root
    - group: root

# this fixes issues with file globbing, see https://github.com/saltstack/salt/issues/24436
/etc/nftables.d/.keep:
  file.managed:
    - replace: False


nftables:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nftables.conf

include:
  - nftables.stateful

