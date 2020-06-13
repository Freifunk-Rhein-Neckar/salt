---

{% for domain in salt['pillar.get']('domains', {}).keys() %}
  {% set domain_id = salt['pillar.get']('domains:%s:domain_id'|format(domain)) %}
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

  {% if 'gateway' in salt['pillar.get']('roles', []) %}
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

ifup-dom{{ domain_id }}-br:
  cmd.run:
    - name: /sbin/ifup dom{{ domain_id }}-br
    # this condition only works for bridges, as they are virtual interfaces
    - unless: /sbin/ip link show dev dom{{ domain_id }}-br
    # - require:
    #   - cmd: udev reload
{% endfor %}

{% if 'gateway' in salt['pillar.get']('roles', []) %}
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
