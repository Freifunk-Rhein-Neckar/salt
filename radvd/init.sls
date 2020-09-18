---

radvd:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/radvd.conf


/etc/radvd.conf:
  file.managed:
    - source: salt://radvd/files/radvd.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
