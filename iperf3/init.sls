---

iperf3:
  pkg.installed: []
  user.present:
    - shell: /usr/sbin/nologin
    - createhome: False

/etc/systemd/system/iperf3.service:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - group: systemd-network
    - mode: '0640'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "iperf3"
            - Requires: "network.target"
          - Service:
            - ExecStart: "/usr/bin/iperf3 --server"
            - User: "iperf3"
          - Install:
            - WantedBy: "multi-user.target"
