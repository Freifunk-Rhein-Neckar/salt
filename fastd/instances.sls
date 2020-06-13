---
{% import 'nftables/macro.sls' as nftables %}

# for each domain
{%- for domain_key, domain_val in salt['pillar.get']('domains', {}).items() %}
  {%- set domain_id = domain_val['domain_id'] %}

  # assign fastd configuration
  {%- set fastd = salt['pillar.get']('domains:%s:fastd'|format(domain_key)) %}

/etc/nftables.d/20-fastd-dom{{ domain_id }}.conf:
  file.managed:
    - source: salt://fastd/files/nftables.conf.j2
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
        domain_id: {{ domain_id }}

# and for each instance (varying mtu/port)
  {%- for instance in fastd['instances'] %}
    {%- set fastd_config_root = '/etc/fastd/dom{}_{}'.format(domain_id, instance['mtu']) %}

# create working directory
{{ fastd_config_root }}:
  file.directory:
    - mode: '0755'
    - makedirs: True

# deploy fastd.conf
{{ fastd_config_root }}/fastd.conf:
  file.managed:
    - source:
      - salt://fastd/files/fastd-{{ domain_id }}.conf.j2
      - salt://fastd/files/fastd-default.conf.j2
    - user: root
    - group: root
    - mode: '0600'
    - template: jinja
    - context:
        domain: {{ domain_key }}
        domain_id: {{ domain_id }}
        port: {{ instance['port'] }}
        mtu: {{ instance['mtu'] }}

# enable instances and watch for config changes
fastd@dom{{ domain_id }}_{{ instance['mtu'] }}:
  service.running:
    - enable: True
    - require:
      - pkg: fastd
    {%- for group_name, group in salt['pillar.get']('fastd:peer_groups').items() %}
      - git: /var/lib/fastd/peer_groups/{{ group_name }}
    {% endfor %}
    - watch:
      - file: {{ fastd_config_root }}/fastd.conf

  {%- endfor %}
{%- endfor %}
