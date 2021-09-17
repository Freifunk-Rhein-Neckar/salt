---
# nginx.nftables
#
# Adds the nginx firewall options
{% import 'nftables/macro.sls' as nftables %}


{{ nftables.include('40-chrony', 'salt://chrony/files/nftabels.conf.j2' ) }}
