---
include:
  - .service

/etc/systemd/network/30-br-vm.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "br-vm"
            - Kind: "bridge"
          - Bridge:
            - STP: "off"
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/30-br-vm.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "br-vm"
          - Network:
            - Address: "{{ salt['pillar.get']('network:br-vm:network:publicv4:address') }}/{{ salt['pillar.get']('network:br-vm:network:publicv4:mask', '32') }}"
            - Address: "{{ salt['pillar.get']('network:br-vm:network:privatev4:range') }}{{ salt['pillar.get']('network:br-vm:network:privatev4:bridge-ip', '1') }}/{{ salt['pillar.get']('network:br-vm:network:privatev4:mask', '24') }}"
            - Address: "{{ salt['pillar.get']('network:br-vm:network:publicv6:range') }}{{ salt['pillar.get']('network:br-vm:network:publicv6:bridge-ip', ':3') }}/{{ salt['pillar.get']('network:br-vm:network:publicv6:mask', '64') }}"
            - Address: "{{ salt['pillar.get']('network:br-vm:network:privatev6:range') }}{{ salt['pillar.get']('network:br-vm:network:privatev6:bridge-ip', ':1') }}/{{ salt['pillar.get']('network:br-vm:network:privatev6:mask', '64') }}"
            - Address: "fe80::1/64"
{%- for family in [6,4] %}
  {%- for ip in salt['pillar.get']('network:br-vm:additional_ipv' + family|string, []) %}
          - Route:
    {%- if grains['systemd']['version']|int < 242 %}
            #- "#GatewayOnlink": "true"
    {%- else %}
            #- GatewayOnLink: "true"
    {%- endif %}
    {%- if ip is mapping %}
      {% for key, value in ip.items() %}
            - Destination: "{{ key }}"
        {% for key2 in value %}
          {%- for key3, value3 in key2.items() %}
            - "{{ key3 }}": "{{ value3 }}"
          {%- endfor %}
        {%- endfor %}
      {%- endfor %}
    {%- else %}
            - Destination: "{{ ip }}"
    {%- endif %}
            - Scope: "link"
  {% endfor %}
{% endfor %}
    - watch_in:
      - service: systemd-networkd
