---
{% import 'nftables/macro.sls' as nftables %}
{{ nftables.include('50-dhcpd-exporter', 'salt://dhcpv4/files/nftables-exporter.conf.j2' ) }}

dhcpd-exporter:
  user.present:
    - home: /var/lib/dhcpd-exporter
    - shell: /usr/sbin/nologin

virtualenv:
  pkg.installed

/var/lib/dhcpd-exporter/venv:
  virtualenv.managed:
    - user: dhcpd-exporter
    - venv_bin: virtualenv
    - python: /usr/bin/python3
    - pip_upgrade: True
    - pip_pkgs:
      - prometheus_client
      - isc_dhcp_filter
    - require:
      - user: dhcpd-exporter
      - pkg: virtualenv
    - require_in:
      - service: dhcpd-exporter.service
    - watch_in:
      - service: dhcpd-exporter.service

https://github.com/andir/dhcpd-exporter.git:
  git.latest:
    - target: /var/lib/dhcpd-exporter/dhcpd-exporter
    - user: dhcpd-exporter
    - force_fetch: True
    - force_reset: True
    - refspec_branch: master
    - require:
      - user: dhcpd-exporter
    - require_in:
      - service: dhcpd-exporter.service
    - watch_in:
      - service: dhcpd-exporter.service

/etc/systemd/system/dhcpd-exporter.service:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0644'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "Prometheus ISC DHCP Daemon Exporter"
            - Wants: "network.target"
            - After: "network.target"
          - Service:
            - Type: "simple"
            - User: "dhcpd-exporter"
            - Group: "dhcpd-exporter"
            - WorkingDirectory: "/var/lib/dhcpd-exporter/dhcpd-exporter"
            - ExecStart: "/var/lib/dhcpd-exporter/venv/bin/python3 dhcpd-exporter.py /var/lib/dhcp/dhcpd.leases{% for subnet in salt['domains.domain_subnets']() %} {{ subnet }}{% endfor %}"
            - Restart: "always"
            - RestartSec: "5s"
          - Install:
            - WantedBy: "multi-user.target"
    - require_in:
      - service: dhcpd-exporter.service
    - watch_in:
      - service: dhcpd-exporter.service

dhcpd-exporter.service:
  service.running:
    - enable: True

prometheus_dhcpd_export:
  grains.present:
    - value: {{ grains.fqdn }}:9267
