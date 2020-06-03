---
# nginx.nftables
#
# Adds the nginx firewall options
{% import 'nftables/macro.sls' as nftables %}


{{ nftables.include('40-nginx', 'salt://nginx/files/nftabels.conf.j2' ) }}
