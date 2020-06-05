---
include:
  - knot

{{ salt['pillar.get']('knot:zones-repository:remote') }}:
  git.latest:
    - branch: {{ salt['pillar.get']('knot:zones-repository:branch', 'master') }}
    - target: /var/lib/knot/zones
    - watch_in:
      - service: knot
    - require:
      - pkg: knot
