---

{% import 'nftables/macro.sls' as nftables %}

{% set host_id = salt['pillar.get']('host:id:primary')|int %}
{% set wg_port = salt['pillar.get']('wg:wg-ffrn-in:port') %}

include:
  - wireguard
  - .service
{% if salt['grains.get']('id') != "master.ffrn.de" %}
{% if salt['pillar.get']('nftables:enabled', True) %}
  - nftables

{{ nftables.include('30-wg-ffrn-in', 'salt://systemd/networkd/files/nftabels-wg-ffrn-in.conf.j2' ) }}

{% else %}
ufw_wg-ffrn-in:
  cmd.run:
    - name: "ufw allow proto udp to any port {{ wg_port }}"
{% endif %}
{% endif %}
/etc/systemd/network/60-wg-ffrn-in.netdev:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - NetDev:
            - Name: "wg-ffrn-in"
            - Kind: "wireguard"
            - Description: "WireGuard tunnel wg-ffrn-in"
          - WireGuard:
            - ListenPort: "{{ wg_port }}"
            - PrivateKey: "{{ salt['pillar.get']('wg:wg-ffrn-in:PrivateKey') }}"
      {% for sections in salt['pillar.get']('wg:wg-ffrn-in:peers') %}
        {%- for section, settings in sections.items() %}
          {%- if section != salt['grains.get']('id') %}
          - WireGuardPeer:
            {%- if section != "" %}
            - Endpoint: {{ section }}:{{ wg_port }}
            {%- endif %}
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

/etc/systemd/network/60-wg-ffrn-in.network:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Match:
            - Name: "wg-ffrn-in"
        {% for sections in salt['pillar.get']('network:wg-ffrn-in:network') %}
          - {{ sections }}
        {% endfor %}
          - Route:
            - Destination: "fd34:fe56:7891::/48"
    - watch_in:
      - service: systemd-networkd
