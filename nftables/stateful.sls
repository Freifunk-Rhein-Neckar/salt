---

/etc/nftables.conf:
  file.managed:
    - source: salt://nftables/files/nftables-stateful.conf.j2
    - user: root
    - group: root
    - mode: '0744'
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - pkg: nftables

{% if 'gateway4' in salt['pillar.get']('roles', []) or 'gateway6' in salt['pillar.get']('roles', []) or 'vmhost' in salt['pillar.get']('roles', []) %}
/etc/nftables.d/10-network.conf:
  file.managed:
    - source: salt://nftables/files/10-network.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
{% endif %}

{% if 'vmhost' in salt['pillar.get']('roles', []) %}
/etc/nftables.d/15-vmhost.conf:
  file.managed:
    - source: salt://nftables/files/15-vmhost.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: nftables
    - require:
      - file: /etc/nftables.d
{% endif %}
