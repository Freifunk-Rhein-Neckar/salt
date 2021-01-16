---
fastd:
  pkg.installed:
    - fromrepo: {{ grains['oscodename'] }}-backports

/etc/apt/preferences.d/backports-fastd:
  file.managed:
    - contents: |
        Package: fastd
        Pin: release n={{ grains['oscodename'] }}-backports
        Pin-Priority: 900

/opt/ff-tools/fastd-statistics.py:
  file.managed:
    - source: salt://fastd/files/fastd-statistics.py
    - makedirs: True
    - mode: 755

chmod 777 /run/fastd-dom0-vpn-1312.sock:
  cron.present:
    - identifier: set rights for fastd.sock
    - user: root
    - commented: False

tun:
  kmod.present:
    - persist: True

fastd_disable_generic_autostart:
  file.replace:
    - name: /etc/default/fastd
    - pattern: ^AUTOSTART=(.*)$
    - repl: AUTOSTART="none"
    - require:
      - pkg: fastd

include:
  - .peergroup
  - .instances
  - .exporter
