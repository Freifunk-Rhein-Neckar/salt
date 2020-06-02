---
yanic-to-zonefile:
  user.present:
    - home: /var/lib/yanic-to-zonefile
    - shell: /usr/sbin/nologin
  git.latest:
    - name: https://github.com/Freifunk-Rhein-Neckar/yanicOutputToZonefile.git
    - target: /var/lib/yanic-to-zonefile/yanicOutputToZonefile
    - force_fetch: True
    - force_reset: True
    - refspec_branch: master
    - user: yanic-to-zonefile
    - require:
      - user: yanic-to-zonefile

/etc/systemd/system/yanic-to-zonefile.service:
  file.managed:
    - source: salt://yanic/files/yanic-to-zonefile.service
    - user: root
    - group: root
    - mode: '0644'

/etc/systemd/system/yanic-to-zonefile.timer:
  file.managed:
    - source: salt://yanic/files/yanic-to-zonefile.timer
    - user: root
    - group: root
    - mode: '0644'

/var/lib/yanic-to-zonefile/yanicOutputToZonefile/config.py:
  file.managed:
    - source: salt://yanic/files/yanic-to-zonefile-config.py
    - user: yanic-to-zonefile
    - group: yanic-to-zonefile

yanic-to-zonefile.timer:
  service.running:
    - enable: True
    - require:
      - file: /var/lib/yanic-to-zonefile/yanicOutputToZonefile/config.py
    - watch:
      - file: /etc/systemd/system/yanic-to-zonefile.service
      - file: /etc/systemd/system/yanic-to-zonefile.timer

/var/lib/knot/nodes.ffrn.de.zone:
  file.symlink:
    - target: /var/lib/yanic-to-zonefile/nodes.ffrn.de.zone

/etc/systemd/system/yanic-to-zonefile-reload.service:
  file.managed:
    - source: salt://yanic/files/yanic-to-zonefile-reload.service
    - user: root
    - group: root
    - mode: '0644'

/etc/systemd/system/yanic-to-zonefile-reload.path:
  file.managed:
    - source: salt://yanic/files/yanic-to-zonefile-reload.path
    - user: root
    - group: root
    - mode: '0644'

yanic-to-zonefile-reload.path:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/yanic-to-zonefile-reload.service
      - file: /etc/systemd/system/yanic-to-zonefile-reload.path
