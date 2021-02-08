---
include:
  - nftables
{% if 'gateway4' in salt['pillar.get']('roles', []) %}
  - nftables.tables.nat4
{% endif %}
{% if 'gateway4' in salt['pillar.get']('roles', []) or 'gateway6' in salt['pillar.get']('roles', []) %}
  - nftables.tables.mangle
{% endif %}
  - network

{%- set host_id = salt['pillar.get']('host:id:primary') -%}

{% for domain in salt['pillar.get']('domains', {}).keys() %}
  {% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
  {% set with_fastd = salt['pillar.get']('domains:%s:fastd'|format(domain), False) %}
  {% set with_batman_adv = salt['pillar.get']('domains:%s:batman-adv'|format(domain), False) %}

/etc/network/interfaces.d/dom{{ domain_id }}.cfg:
  file.managed:
    - source: salt://network/files/interfaces-domain.j2
    - mode: '0644'
    - user: root
    - group: root
    - template: jinja
    - require:
      - file: /etc/network/interfaces.d
    - context:
        domain: {{ domain }}
        domain_id: {{ domain_id }}
        host_id: {{ host_id }}

/etc/iproute2/rt_tables.d/dom{{ domain_id }}-int.conf:
  file.managed:
    - name:
    - contents: "{{ domain_id+2 }}    dom{{ domain_id }}-int"

  {% if 'gateway4' in salt['pillar.get']('roles', []) or 'gateway6' in salt['pillar.get']('roles', []) %}
/etc/nftables.d/20-dom{{ domain_id }}.conf:
  file.managed:
    - source: salt://network/files/nftables-gw-domain.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
    - context:
        domain: {{ domain }}
        domain_id: {{ domain_id }}
  {% endif %}

  {% if with_batman_adv %}
/root/network-dom{{ domain_id }}-bat-up.sh:
  file.managed:
    - mode: '0740'
    - contents: |
          #!/usr/bin/env bash

          ip link add dom{{ domain_id }}-bat type batadv
          ip link set up dev dom{{ domain_id }}-bat

dom{{ domain_id }}-network-up-cron:
  cron:
    {%- if not ("roles" in pillar and 'gateway4' in pillar.roles and with_fastd) %}
    - present
    {%- else %}
    - absent
    {%- endif %}
    - name: "sleep 15 && /root/network-dom{{ domain_id }}-bat-up.sh"
    - user: root
    - identifier: dom{{ domain_id }}-network-up
    - special: '@reboot'
    - comment: "set dom{{ domain_id }}-bat up"
  {% endif %}
{% endfor %}

{% if 'gateway4' in salt['pillar.get']('roles', []) or 'gateway6' in salt['pillar.get']('roles', []) %}
/etc/nftables.d/10-network.conf:
  file.managed:
    - source: salt://network/files/nftables-gw.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
{% endif %}
