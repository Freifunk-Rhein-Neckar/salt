---
smartmontools:
  pkg.installed: []

/etc/sudoers.d/telegraf-smart:
  file.managed:
    - user: root
    - group: root
    - mode: '0440'
    - source: salt://telegraf/inputs/files/sudoers-smart
    - check_cmd: /usr/sbin/visudo -c -f
