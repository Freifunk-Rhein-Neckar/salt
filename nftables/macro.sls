---
{% macro include(name, path) %}
/etc/nftables.d/{{ name }}.conf:
  file.managed:
    - source: {{ path }}
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
{% endmacro %}
