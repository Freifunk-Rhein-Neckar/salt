---
include:
  - .service
  - .wg-ffrn

{% set host_id = salt['pillar.get']('host:id:primary') %}
{% for domain in salt['pillar.get']('domains', {}).keys() %}

  {% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
  {% set with_batman_adv = salt['pillar.get']('domains:%s:batman-adv'|format(domain), False) %}
  {% set with_fastd = salt['pillar.get']('domains:%s:fastd'|format(domain), False) %}

/etc/systemd/network/70-vxlan-dom{{ domain_id }}.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "dom{{ domain_id }}-vxlan"
            - Kind: "vxlan"
            - MACAddress: "{{ salt['net.clientbr_mac'](domain_id, host_id) }}"
          - VXLAN:
            - Id: {{ salt['pillar.get']('domains:%s:vlan'|format(domain)) }}
            - DestinationPort: "4789"
            - Local: "fdc3:67ce:cc7e:8060::{{ host_id|int }}"
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/70-vxlan-dom{{ domain_id }}.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "dom{{ domain_id }}-vxlan"
          - Network:
    {% for id in [1,2,3,4,5,6,7,8,9,15,16,53,54] %}
      {%- if host_id|int != id %}
          - BridgeFDB:
            - MACAddress: "00:00:00:00:00:00"
            - Destination: "fdc3:67ce:cc7e:8060::{{ id }}"
      {%- endif %}
    {%- endfor %}
    - watch_in:
      - service: systemd-networkd

/root/bridge-fdb-append-dom{{ domain_id }}.sh:
  file.absent: []

{% endfor %}
