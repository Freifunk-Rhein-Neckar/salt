---
include:
  - .service

/etc/systemd/network/10-mainif.link:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          {{ salt['pillar.get']('network:main:link') }}
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/10-mainif.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config: {{ salt['pillar.get']('network:main:network') }}
    - watch_in:
      - service: systemd-networkd
