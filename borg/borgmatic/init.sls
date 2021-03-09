---
include:
  - systemd.daemon-reload
  - apt

{% if grains['oscodename'] == "buster" %}
/etc/apt/preferences.d/borgmatic:
  file.managed:
    - contents: |
        Package: borgmatic
        Pin: release n=bullseye
        Pin-Priority: 900
{% endif %}

borgmatic:
  pkg.installed: []

/etc/borgmatic/config.yaml:
  file.managed:
    - source: salt://borg/borgmatic/files/config.yaml.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'
    - makedirs: True
    - watch_in:
      - service: borgmatic
    - required:
      - pkg: borgmatic

borgmatic init --encryption repokey:
  cmd.watch:
    - watch:
      - file: /etc/borgmatic/config.yaml

/etc/systemd/system/borgmatic.service:
  file.managed:
    - source: salt://borg/borgmatic/files/borgmatic.service
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
    - watch_in:
      - service: borgmatic
    - onchanges_in:
      - cmd: systemctl daemon-reload

/etc/systemd/system/borgmatic.timer:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0644'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "Run borgmatic backup"
          - Timer:
            - OnCalendar: "{{ salt['pillar.get']('borgmatic:timer:OnCalendar', 'daily') }}"
            - Persistent: "true"
            - RandomizedDelaySec: "{{ salt['pillar.get']('borgmatic:timer:RandomizedDelaySec', '25200') }}"
          - Install:
            - WantedBy: "timers.target"
    - require:
      - file: /etc/systemd/system/borgmatic.service
    - onchanges_in:
      - cmd: systemctl daemon-reload

borgmatic.timer:
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/borgmatic.timer
