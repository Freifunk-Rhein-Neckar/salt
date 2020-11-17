---

wireguard:
  pkg.installed: []

{% if salt['grains.get']('osarch') == 'amd64' %}
linux-headers-amd64:
  pkg.installed: []
{% endif %}

/usr/local/bin/watch-wg:
  file.managed:
    - source: salt://wireguard/files/watch-wg.sh
    - mode: 770
