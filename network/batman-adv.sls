---
include:
  - batman_adv

#
# runtime settings
#

{% for domain in salt['pillar.get']('domains', {}) %}
{% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
{% set gw_mode = salt['pillar.get']('domains:%s:batman-adv:gw_mode:enabled'|format(domain), False) %}
{% set features = salt['pillar.get']('domains:%s:batman-adv:features'|format(domain), {}) %}
{% set dat = features.get('dat', True) %}
{% set mm_mode = features.get('mm', False) %}
{% set orig_interval = features.get('orig_interval', 5000) %}

# gateway mode
{% if gw_mode  %}
{%- set uplink = salt['pillar.get']('domains:%s:batman-adv:gw_mode:uplink', '100mbit') %}
{%- set downlink = salt['pillar.get']('domains:%s:batman-adv:gw_mode:uplink', '100mbit') %}
batctl_dom{{ domain_id }}_gw_mode:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat gw server {{ uplink }}/{{ downlink }}
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat gw | awk '{ print $1 }')\" = \"server\" ]"
    - require: 
      - sls: batman_adv.batctl
{% else %}
batctl_dom{{ domain_id }}_gw_mode:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat gw off
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat gw | awk '{ print $1 }')\" = \"off\" ]"
    - require: 
      - sls: batman_adv.batctl
{% endif %}

# dat
{% if dat  %}
batctl_dom{{ domain_id }}_dat:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat dat 1
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat dat)\" = \"enabled\" ]"
    - require: 
      - sls: batman_adv.batctl
{% else %}
batctl_dom{{ domain_id }}_dat:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat dat 0
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat dat)\" = \"disabled\" ]"
    - require: 
      - sls: batman_adv.batctl
{% endif %}

# originator interval
batctl_dom{{ domain_id }}_orig_interval:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat orig_interval {{ orig_interval }}
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat orig_interval)\" = \"{{ orig_interval }}\" ]"
    - require: 
      - sls: batman_adv.batctl

# multicast mode
{% if mm_mode %}
batctl_dom{{ domain_id }}_mm_mode:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat mm 1
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat mm)\" = \"enabled\" ]"
    - require: 
      - sls: batman_adv.batctl
clientbr_dom{{ domain_id }}_multicast_snooping:
  cmd.run:
    - name: echo 1 > /sys/class/net/dom{{ domain_id }}-br/bridge/multicast_snooping
    - unless: "[ \"$(cat /sys/class/net/dom{{ domain_id }}-br/bridge/multicast_snooping)\" -eq \"1\" ]"
    - require: 
      - sls: batman_adv.batctl
{% else %}
batctl_dom{{ domain_id }}_mm_mode:
  cmd.run:
    - name: batctl meshif dom{{ domain_id }}-bat mm 0
    - unless: "[ \"$(batctl meshif dom{{ domain_id }}-bat mm)\" = \"disabled\" ]"
    - require: 
      - sls: batman_adv.batctl
clientbr_dom{{ domain_id }}_multicast_snooping:
  cmd.run:
    - name: echo 0 > /sys/class/net/dom{{ domain_id }}-br/bridge/multicast_snooping
    - unless: "[ \"$(cat /sys/class/net/dom{{ domain_id }}-br/bridge/multicast_snooping)\" -eq \"0\" ]"
    - require: 
      - sls: batman_adv.batctl
{% endif %}
{% endfor %}
