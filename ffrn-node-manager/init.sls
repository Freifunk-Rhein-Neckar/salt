---
include:
  - systemd.daemon-reload

ffrn-node-manager_base:
  pkg.installed:
    - pkgs:
      - python3
      - python3-venv

ffrn-node-manager:
  user.present:
    - shell: /usr/sbin/nologin
    - createhome: False
  service.running:
    - enable: True
    - name: ffrn-node-manager.socket
    - require:
      - pkg: ffrn-node-manager_base
      - virtualenv: /opt/ffrn-node-manager/venv

https://github.com/Freifunk-Rhein-Neckar/ffrn-node-manager.git:
  git.latest:
    - target: /opt/ffrn-node-manager
    - user: ffrn-node-manager
    - watch_in:
      - service: ffrn-node-manager
      - user: ffrn-node-manager

/opt/ffrn-node-manager/venv:
  virtualenv.managed:
    - requirements: /opt/ffrn-node-manager/requirements.txt
    - user: ffrn-node-manager

/etc/systemd/system/ffrn-node-manager.service:
  file.managed:
    - source: salt://ffrn-node-manager/files/ffrn-node-manager.service.j2
    - template: jinja
    - mode: '0644'
    - makedirs: True
    - onchanges_in:
      - cmd: systemctl daemon-reload
    - watch_in:
      - service: ffrn-node-manager

/etc/systemd/system/ffrn-node-manager.socket:
  file.managed:
    - source: salt://ffrn-node-manager/files/ffrn-node-manager.socket.j2
    - template: jinja
    - mode: '0644'
    - makedirs: True
    - onchanges_in:
      - cmd: systemctl daemon-reload
    - watch_in:
      - service: ffrn-node-manager
