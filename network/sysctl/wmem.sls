---

{% from './init.sls' import sysctld with context %}

net.core.wmem_max:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/wmem_max.conf

net.core.wmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/wmem_default.conf
