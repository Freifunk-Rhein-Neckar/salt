---

{# /etc/apt/preferences.d/backports-nftables:
  file.managed:
    - contents: |
        Package: nftables libnftables1 libnftnl11
        Pin: release n=buster-backports
        Pin-Priority: 900 #}

/etc/nftables.d:
  file.directory:
    - user: root
    - group: root

/etc/nftables.d/.keep:
  file.absent: []

nftables:
  pkg.installed: []
{%- if salt['pillar.get']('nftables:enabled', True) %}
  service.running:
    - enable: True
    - reload: True
{%- else %}
  service.dead:
    - enable: False
{% endif %}

include:
{%- if 'vmhost' in salt['pillar.get']('roles', []) %}
  {# - nftables.stateless #}
  - nftables.stateful
{%- else %}
  - nftables.stateful
{% endif %}
