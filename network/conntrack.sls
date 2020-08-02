---
{% set sysctld = "/etc/sysctl.d" %}

nf_conntrack:
  kmod.present:
    - persist: True

net.netfilter.nf_conntrack_max:
  sysctl.present:
    - value: 256000
    - config: {{ sysctld }}/conntrack.conf
