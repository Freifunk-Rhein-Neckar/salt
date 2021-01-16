---
# dhcp4
#
# Manage installation of isc-dhcp-server

include:
  - .exporter
  - nftables

isc-dhcp-server:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/dhcp/dhcpd.conf
    - require:
      - file: /etc/systemd/system/isc-dhcp-server.service

/etc/systemd/system/isc-dhcp-server.service:
  file.managed:
    - source: salt://dhcpv4/files/isc-dhcp-server.service
    - user: root
    - group: root
    - mode: '0644'
    - watch_in:
      - service: isc-dhcp-server

# primary config with conf.d include
/etc/dhcp/dhcpd.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpd.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/dhcp/conf.d:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: '0755'

# instance configurations
{% for domain_key, domain_val in salt['pillar.get']('domains', {}).items() %}
/etc/dhcp/conf.d/dom{{ domain_val['domain_id'] }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/domain.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        domain: {{ domain_key }}
    - require:
      - file: /etc/dhcp/conf.d
    - watch_in:
      - service: isc-dhcp-server

/etc/nftables.d/50-dhcp-dom{{ domain_val['domain_id'] }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/nftables.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
    - context:
        domain: {{ domain_key }}
        domain_id: {{ domain_val['domain_id'] }}

{% endfor %}
