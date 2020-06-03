---
knot:
  pkg.installed: []
  service.running:
    - name: knot
    - enable: True
    - reload: True
    - watch:
      - file: /etc/knot/knot.conf
    - require:
      - pkg: knot


/etc/knot/knot.conf:
  file.managed:
    - source: salt://knot/files/knot.conf.j2
    - makedirs: True
    - user: knot
    - group: knot
    - template: jinja
    - mode: '0640'
    - require:
      - pkg: knot
