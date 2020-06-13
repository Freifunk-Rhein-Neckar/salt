---
{% import 'nftables/macro.sls' as nftables %}

{{ nftables.include('50-mesh-announce', 'salt://mesh-announce/files/nftables.conf.j2' ) }}

https://git.darmstadt.ccc.de/ffda/infra/mesh-announce.git:
  git.latest:
    - target: /opt/mesh-announce
    - force_fetch: true
    - force_reset: true
    - refspec_branch: master
    - rev: master
    - watch_in:
      - service: mesh-announce
    - require_in:
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

mesh-announce_deps:
  pkg.installed:
    - pkgs:
      - ethtool
      - lsb-release
      - python3-netifaces

mesh-announce:
  service.running:
    - enable: True
    - require:
      - file: /etc/mesh-announce/mesh-announce.conf
      - file: /etc/systemd/system/mesh-announce.service
      - pkg: mesh-announce_deps
    - watch:
      - file: /etc/mesh-announce/mesh-announce.conf
      - file: /etc/systemd/system/mesh-announce.service
