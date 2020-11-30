---
salt-minion:
  service.running:
    - enable: True
#     - watch:
#       - file: /etc/salt/minion.d

/etc/salt/minion.d:
  file.recurse:
    - source: salt://salt/files/minion.d
    - clean: True
    - exclude_pat: _schedule.conf
