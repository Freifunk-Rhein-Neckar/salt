import logging

# enumerate networks for address family
def all_networks(family):
    tmp = []
    for domain in __salt__['pillar.get']('domains'):
        nets = __salt__['pillar.get']('domains:{0}:{1}'.format(domain, family), {})
        tmp.extend(nets.keys())
    return tmp

# check if ip addresses need to be configured
def has_ip_addrs(domain):
    for family in ('ip4', 'ip6'):
        for net in __salt__['pillar.get']('domains:{0}:ip4'.format(domain)).values():
            if 'address' in net:
                return True
    return False

# enumerate local ip addresses
def local_addrs(family):
    # service addrs
    yield service_ip(family, __salt__['pillar.get']('host:id:primary'))
    if __salt__['pillar.get']('host:id:secondary', False):
        yield service_ip(family, __salt__['pillar.get']('host:id:secondary'))

    # mesh domain addrs
    for domain in __salt__['pillar.get']('domains', {}).keys():
        for net in __salt__['pillar.get']('domains:{0}:ip{1}'.format(domain, family), {}).values():
            if 'address' in net:
                yield net['address']

# compose mac for interfaces
def clientbr_mac(domain_id, host_id):
    return ":".join(['6A', 'FF', '94', str(domain_id).zfill(2), str(host_id), '04'])

def batadv_mac(domain_id, host_id):
    return ":".join(['6A', 'FF', '94', str(domain_id).zfill(2), str(host_id), '02'])
