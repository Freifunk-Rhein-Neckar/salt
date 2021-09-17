# knot-resolver.pkg
#
# Manage installation of knot-resolver

knot-resolver_install:
  pkg.installed:
    - pkgs:
      - knot-resolver
      - knot-resolver-module-http

{% if salt['grains.get']('os_family') == 'Debian' %}
knot-resolver_official_repo:
  pkgrepo.managed:
    - humanname: knot-resolver apt repo
    - name: deb http://download.opensuse.org/repositories/home:/CZ-NIC:/knot-resolver-latest/{{ grains['os'] }}_{{ grains['osmajorrelease'] }} /
    - file: /etc/apt/sources.list.d/knot-resolver-latest.list
    - key_url: salt://knot-resolver/files/cznic-obs.gpg
    - require_in:
      - pkg: knot-resolver_install
    - watch_in:
      - pkg: knot-resolver_install
{% endif %}
