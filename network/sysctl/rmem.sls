---

{% from './init.sls' import sysctld with context %}

net.core.rmem_max:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem_max.conf

net.core.rmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem_default.conf
