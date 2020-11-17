---
include:
  - .service
  - network.domains
  - .vxlan

{% for domain in salt['pillar.get']('domains', {}).keys() %}

  {% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
  {% set host_id = salt['pillar.get']('host:id:primary') %}
  {% set with_batman_adv = salt['pillar.get']('domains:%s:batman-adv'|format(domain), False) %}
  {% set with_fastd = salt['pillar.get']('domains:%s:fastd'|format(domain), False) %}

/etc/systemd/network/40-br-mesh-dom{{ domain_id }}.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "dom{{ domain_id }}-br"
            - Kind: "bridge"
            - MACAddress: "{{ salt['net.clientbr_mac'](domain_id, host_id) }}"
          - Bridge:
            - STP: "off"
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/40-br-mesh-dom{{ domain_id }}.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "dom{{ domain_id }}-br"
          - Network:
    {%- for family in [4,6] %}
      {%- for network in salt['pillar.get'](('domains:%s:ip' ~ family) |format(domain), {}).values() if 'address' in network and 'prefixlen' in network %}
            - Address: "{{ network['address'] }}/{{ network['prefixlen'] }}"
      {%- endfor %}
    {%- endfor %}
            - IPv6AcceptRA: "false"
    {%- for family in [4,6] %}
      {%- for network in salt['pillar.get'](('domains:%s:ip' ~ family) |format(domain), {}).values() if 'address' not in network %}
          - Route:
            - Destination: "{{ network['network'] }}/{{ network['prefixlen'] }}"
      {%- endfor %}
    {%- endfor %}
    {%- if host_id|int != 1 %}
      {% for network in salt['pillar.get']('domains:%s:ip6'|format(domain), {}).values() if 'int' in network and network['int'] == True %}
          - RoutingPolicyRule:
            - Family: "ipv6"
            - From: "{{ network['network'] }}/{{ network['prefixlen'] }}"
            - Table: "{{ domain_id+2 }}"
          - Route:
            - GatewayOnLink: "true"
            - Destination: "{{ network['network'] }}/{{ network['prefixlen'] }}"
            - Table: "{{ domain_id+2 }}"
          - Route:
            - GatewayOnLink: "true"
            - Gateway: "{{ network['network'] }}1"
            - Table: "{{ domain_id+2 }}"
      {%- endfor %}
    {% endif %}
    - watch_in:
      - service: systemd-networkd
    - require:
      - file: /etc/iproute2/rt_tables.d/dom{{ domain_id }}-int.conf

/etc/systemd/network/80-dummy-br-dom{{ domain_id }}.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "dom{{ domain_id }}-dummy"
            - Kind: "dummy"
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/80-dummy-br-dom{{ domain_id }}.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "dom{{ domain_id }}-dummy"
          - Network:
            - Bridge: "dom{{ domain_id }}-br"
    - watch_in:
      - service: systemd-networkd

{% endfor %}
