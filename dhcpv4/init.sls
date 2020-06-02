# dhcp4
#
# Manage installation of isc-dhcp-server

isc-dhcp-server:
  pkg.installed: []
  service.running:
    - name: isc-dhcp-server
    - enable: True
    - watch:
      - file: /etc/dhcp/dhcpd.conf


# primary config with conf.d include
/etc/dhcp/dhcpd.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpd.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
