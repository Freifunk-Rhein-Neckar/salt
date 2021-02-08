---
include:
  - wireguard
  - .service

{% set host_id = salt['pillar.get']('host:id:primary')|int %}
{% set wg_port = salt['pillar.get']('wg:wg-ffrn:port') %}

/etc/systemd/network/60-wg-ffrn.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "wg-ffrn"
            - Kind: "wireguard"
            - Description: "WireGuard tunnel wg-ffrn"
          - WireGuard:
            - ListenPort: "{{ wg_port }}"
            - PrivateKey: "{{ salt['pillar.get']('wg:wg-ffrn:PrivateKey') }}"
      {% for sections in salt['pillar.get']('wg:wg-ffrn:peers') %}
        {%- for section, settings in sections.items() %}
          {%- if section != salt['grains.get']('id') ~ ":" ~ wg_port %}
          - WireGuardPeer:
            - Endpoint: {{ section }}
            {%- for setting in settings -%}
              {%- for key, value in setting.items() %}
            - {{ key }}={{ value }}
              {% endfor %}
            {% endfor %}
          {% endif %}
        {% endfor %}
      {% endfor %}
    - watch_in:
      - service: systemd-networkd

/etc/systemd/network/60-wg-ffrn.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "wg-ffrn"
          - Network:
            - Address: "10.100.0.{{ host_id }}/24"
            - Address: "fdc3:67ce:cc7e:8060::{{ host_id }}/64"
{% for domain in salt['pillar.get']('domains', {}).keys() %}
  {% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
            - VXLAN: "dom{{ domain_id }}-vxlan"
{% endfor %}
          - Route:
            - Destination: "fdc3:67ce:cc7e:8000::/56"
            - Scope: "link"
    - watch_in:
      - service: systemd-networkd
