---

{% import 'nftables/macro.sls' as nftables %}

{{ nftables.include('40-knot-resolver', 'salt://knot-resolver/files/nftabels.conf.j2' ) }}
