---

salt-master:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/master.d

/etc/salt/master.d:
  file.recurse:
    - source: salt://salt/master/files/master.d
    - clean: True
