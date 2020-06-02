# knot-resolver.service
#
# Manages the knot-resolver service.

include:
  - .pkg

kresd@1_service:
  service.running:
    - name: kresd@1
    - enable: True
    - require:
      - sls: knot-resolver.pkg
    - listen:
      - pkg: knot-resolver_install


kresd@2_service:
  service.running:
    - name: kresd@2
    - enable: True
    - require:
      - sls: knot-resolver.pkg
    - watch:
      - service: kresd@1_service
