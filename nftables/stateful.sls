---
/etc/nftables.conf:
  file.managed:
    - source: salt://nftables/files/nftables-stateful.conf.j2
    - user: root
    - group: root
    - mode: '0744'
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - pkg: nftables
