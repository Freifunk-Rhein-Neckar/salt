---
{% import 'nftables/macro.sls' as nftables %}

{{ nftables.include('05-mangle', 'salt://nftables/tables/files/mangle.conf.j2' ) }}
