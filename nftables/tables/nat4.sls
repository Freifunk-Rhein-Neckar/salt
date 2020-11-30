---
{% import 'nftables/macro.sls' as nftables %}

{{ nftables.include('05-nat', 'salt://nftables/tables/files/nat4.conf.j2' ) }}
