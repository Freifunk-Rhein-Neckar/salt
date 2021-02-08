---

{% set default_keys = salt['pillar.get']('ssh:known_hosts') %}

{% for block_name, blockvar in default_keys.items() %}
{{ block_name }}:
  ssh_known_hosts.present:
  {%- for block_name2, blockvar2 in blockvar.items() %}
    - {{ block_name2 }}: "{{ blockvar2 }}"
  {%- endfor %}
{% endfor %}
