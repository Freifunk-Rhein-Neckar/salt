---
chrony:
  pkg.installed: []
  service.running:
    - enable: True

/etc/chrony/chrony.conf:
  file.managed:
    - source: salt://chrony/files/chrony.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: chrony
    - watch_in:
      - service: chrony
