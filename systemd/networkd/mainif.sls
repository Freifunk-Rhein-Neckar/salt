---
include:
  - .service

{% set mainif_link = salt['pillar.get']('network:main:link') %}

{% if mainif_link != "" %}
/etc/systemd/network/10-mainif.link:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          {{ mainif_link }}
    - watch_in:
      - service: systemd-networkd
{% endif %}

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
