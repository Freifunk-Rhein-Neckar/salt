---
include:
  - knot

/var/lib/knot:
  git.latest:
    - order: 1
    - name: {{ salt['pillar.get']('knot:zones-repository:remote') }}
    - branch: {{ salt['pillar.get']('knot:zones-repository:branch', 'master') }}
    - target: /var/lib/knot
    - watch_in:
      - service: knot
