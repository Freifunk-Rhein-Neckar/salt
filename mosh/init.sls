---
{% if salt['pillar.get']('nftables:enabled', True) %}
include:
  - nftables
{% import 'nftables/macro.sls' as nftables %}
{{ nftables.include('20-mosh', 'salt://mosh/files/nftabels.conf.j2' ) }}
{% else %}
mosh-ufw:
 cmd.run:
   - name: "ufw allow mosh"
{% endif %}

mosh:
  pkg.installed: []
