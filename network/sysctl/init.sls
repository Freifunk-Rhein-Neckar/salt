---

{% set sysctld = "/etc/sysctl.d" %}

include:
  - .neigh
  - .forwarding
  - .rmem
  - .wmem
