---

ffrn-website:
  git.latest:
    - name: https://github.com/Freifunk-Rhein-Neckar/website.git
    - target: /var/www/website
    - rev: gh-pages
    - refspec_branch: gh-pages
    - force_fetch: True
    - force_reset: True

/usr/local/sbin/website-sync:
  file.managed:
    - source: salt://www/files/website-sync.j2
    - user: root
    - group: root
    - mode: '0755'
    - template: jinja

/etc/systemd/system/website-sync.service:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "run website-sync"
          - Service:
            - Type: "oneshot"
            - ExecStart: "/usr/local/sbin/website-sync"
            - User: "root"
    - watch_in:
      - service: website-sync.timer

/etc/systemd/system/website-sync.timer:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "run website-sync every 5 minutes"
          - Timer:
            - OnCalendar: "*-*-* *:0/5:00"
          - Install:
            - WantedBy: "timers.target"
    - watch_in:
      - service: website-sync.timer

website-sync.timer:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/website-sync.timer
      - file: /etc/systemd/system/website-sync.service
      - file: /usr/local/sbin/website-sync
