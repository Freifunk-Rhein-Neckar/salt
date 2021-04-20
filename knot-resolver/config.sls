# knot-resolver.config
#
# Manages the main knot-resolver server configuration file.


/etc/knot-resolver/kresd.conf:
  file.managed:
    - source: salt://knot-resolver/files/kresd.conf.j2
    - makedirs: True
    - user: knot-resolver
    - group: knot-resolver
    - template: jinja
    - mode: '0640'
    - require:
      - pkg: knot-resolver_install
    - watch_in:
      - service: kresd@1_service
