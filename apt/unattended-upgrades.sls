---

unattended-upgrades:
  pkg.installed: []

/etc/apt/apt.conf.d/10periodic:
  file.managed:
    - source: salt://apt/files/10periodic
    - user: root
    - group: root
    - mode: '0644'

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - source: salt://apt/files/50unattended-upgrades
    - user: root
    - group: root
    - mode: '0644'

# Combat Prometheus AptUpdateRequired alert spamminess
/etc/systemd/system/apt-daily.timer.d/predictable_apt-daily.timer.conf:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0644'
    - template: jinja
    - makedirs: True
    - context:
        config:
          - Timer:
            - RandomizedDelaySec: "10min"
    - require_in:
      - service: dhcpd-exporter.service
    - watch_in:
      - service: dhcpd-exporter.service
