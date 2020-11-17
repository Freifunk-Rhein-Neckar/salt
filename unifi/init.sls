---
{% import 'nftables/macro.sls' as nftables %}


{{ nftables.include('40-unifi', 'salt://unifi/files/nftabels.conf.j2' ) }}
