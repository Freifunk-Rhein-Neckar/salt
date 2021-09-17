---

systemd-resolved:
  service.running:
    - enable: True
    - running: True

/etc/systemd/resolved.conf.d/:
  file.directory:
    - makedirs: True

/etc/resolv.conf:
  file.symlink:
    - target: /run/systemd/resolve/stub-resolv.conf
    - force: True

/etc/systemd/resolved.conf.d/fallback_dns.conf:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        config:
          - Resolve:
            - FallbackDNS: "1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001"
    - require:
      - file: /etc/systemd/resolved.conf.d/
    - watch_in:
      - service: systemd-resolved

resolvconf:
  pkg.removed: []
