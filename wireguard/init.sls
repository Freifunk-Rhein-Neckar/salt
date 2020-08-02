---

wireguard:
  pkg.installed: []


linux-headers-amd64:
  pkg.installed: []

/usr/local/bin/watch-wg:
  file.managed:
    - source: salt://wireguard/files/watch-wg.sh
    - mode: 770
