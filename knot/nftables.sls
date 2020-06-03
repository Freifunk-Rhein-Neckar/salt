# knot.nftables
#
# Adds the knot firewall options

{% import 'nftables/macro.sls' as nftables %}


{{ nftables.include('40-knot-dns', 'salt://knot/files/nftabels.conf.j2' ) }}
