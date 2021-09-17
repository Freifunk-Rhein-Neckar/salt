---

{% from './init.sls' import sysctld with context %}

# arp/ndp
net.ipv4.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 2048
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 2048
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf
