---
{% if salt['pillar.get']('nftables:enabled', True) %}
include:
  - nftables
{% import 'nftables/macro.sls' as nftables %}
{{ nftables.include('40-prometheus', 'salt://prometheus/files/node-exporter/nftabels.conf.j2' ) }}
{% else %}
# prom-ex-ipv4:
#  cmd.run:
#    - name: "ufw allow proto tcp from 5.189.157.196 to any port 9100"

#prom-ex-ipv6:
#  cmd.run:
#    - name: "ufw allow proto tcp from 2a02:c207:3001:370::/64 to any port 9100" #}
{% endif %}

prometheus-node-exporter:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/default/prometheus-node-exporter

{% if grains['osfullname'] == "Debian" and grains['osmajorrelease'] >= 11 %}
prometheus-node-exporter-collectors:
  pkg.installed: []
{% endif %}

/etc/default/prometheus-node-exporter:
  file.managed:
    - source:
      - salt://prometheus/files/node-exporter/prometheus-node-exporter.j2.{{ grains['oscodename'] }}
      - salt://prometheus/files/node-exporter/prometheus-node-exporter.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - pkg: prometheus-node-exporter

/etc/tmpfiles.d/prometheus-node-exporter-textfiles.conf:
  file.managed:
    - contents: |
        #Type Path                                     Mode UID  GID  Age Argument
        d     /run/prometheus-node-exporter/textfiles/ 0755 root root -   -
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: prometheus-node-exporter

reload tmpfiles:
  cmd.run:
    - name: systemd-tmpfiles --create
    - onchanges:
      - file: /etc/tmpfiles.d/prometheus-node-exporter-textfiles.conf
