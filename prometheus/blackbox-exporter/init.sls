---
{% import 'nftables/macro.sls' as nftables %}



prometheus-blackbox-exporter:
  debconf.set:
    - data:
        'want_cap_net_raw': {'type': 'boolean', 'value': True}
  pkg.installed: []
  service.running:
    - enable: True

setcap cap_net_raw+ep /usr/bin/prometheus-blackbox-exporter:
  cmd.run:
    - unless: getcap /usr/bin/prometheus-blackbox-exporter | grep -q 'cap_net_raw+ep'
    - require:
      - pkg: prometheus-blackbox-exporter
    - require_in:
      - service: prometheus-blackbox-exporter
    - watch_in:
      - service: prometheus-blackbox-exporter

/etc/default/prometheus-blackbox-exporter:
  file.managed:
    - source: salt://prometheus/blackbox-exporter/files/prometheus-blackbox-exporter
    - user: root
    - group: root
    - mode: '0644'
    - watch_in:
      - service: prometheus-blackbox-exporter
    - require_in:
      - service: prometheus-blackbox-exporter

/etc/prometheus/blackbox.yml:
  file.managed:
    - source: salt://prometheus/blackbox-exporter/files/blackbox.yml.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: prometheus-blackbox-exporter
    - require_in:
      - service: prometheus-blackbox-exporter

{% if 'prometheus' not in salt['pillar.get']('roles', []) %}
# make the blackbox exporter reachable from remote if prometheus isn't local
include:
  - nftables

{{ nftables.include('40-blackbox-exporter', 'salt://prometheus/blackbox-exporter/files/nftabels.conf.j2' ) }}

{% endif %}
