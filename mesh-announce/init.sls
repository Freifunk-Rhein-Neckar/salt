---
{% import 'nftables/macro.sls' as nftables %}

{{ nftables.include('50-mesh-announce', 'salt://mesh-announce/files/nftables.conf.j2' ) }}

mesh-announce:
  user.present:
    - shell: /usr/sbin/nologin
    - createhome: False
  service.running:
    - enable: True
    - require:
      - pkg: mesh-announce_deps
    - watch:
      - file: /etc/mesh-announce/mesh-announce.conf
      - file: /etc/systemd/system/mesh-announce.service

https://github.com/Freifunk-Rhein-Neckar/mesh-announce.git:
  git.latest:
    - target: /opt/mesh-announce
    - force_fetch: true
    - force_reset: true
    - refspec_branch: ffrn_dev
    - rev: ffrn_dev
    - watch_in:
      - service: mesh-announce

/etc/mesh-announce/mesh-announce.conf:
  file.managed:
    - source: salt://mesh-announce/files/mesh-announce.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

/etc/systemd/system/mesh-announce.service:
  file.managed:
    - source: salt://mesh-announce/files/mesh-announce.service.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

/etc/sudoers.d/mesh-announce:
  file.managed:
    - user: root
    - group: root
    - mode: '0440'
    - source: salt://mesh-announce/files/mesh-announce.sudoers.j2
    - check_cmd: /usr/sbin/visudo -c -f

mesh-announce_deps:
  pkg.installed:
    - pkgs:
      - ethtool
      - lsb-release
      - python3-netifaces
