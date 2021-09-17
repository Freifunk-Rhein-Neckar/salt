---
include:
  - systemd.daemon-reload

/etc/systemd/system/network-hardware-offloading.service:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0644'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "Disable gro gso tso offload"
          - Service:
            - Requires: "network.target"
            - After: "network.target"
            - Type: "oneshot"
            - ExecStart: "/sbin/ethtool -K {{ salt['pillar.get']('network:interface', "eth0") }} gro off gso off tso off"
          - Install:
            - WantedBy: "multi-user.target"
    - onchanges_in:
      - cmd: systemctl daemon-reload

network-hardware-offloading.service:
  service.enabled:
    - require:
      - file: /etc/systemd/system/network-hardware-offloading.service

systemctl start network-hardware-offloading.service:
  cmd.run:
    - onchanges:
      - file: /etc/systemd/system/network-hardware-offloading.service
