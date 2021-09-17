---
include:
  - systemd.daemon-reload

{% if salt['pillar.get']('salt-minion:installed', True) %}
/etc/salt/minion.d:
  file.recurse:
    - source: salt://salt/minion/files/minion.d
    - clean: True
    - exclude_pat: 
      - _schedule.conf
      - .*.swp

salt-minion:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/minion.d

/etc/systemd/system/salt-minion.service.d/override.conf:
  file.managed:
    - source: salt://salt/minion/files/salt-minion.override.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
    - onchanges_in:
      - cmd: systemctl daemon-reload

{% endif %}
