import logging

# compose mac for fastd interface
def mac(domain_id, host_id):
    return ":".join(['6A', 'FF', '94', str(domain_id), str(host_id), '03'])

# enumerate fastd instance names for fastd exporter
def all_instances():
    tmp = []
    for domain in __salt__['pillar.get']('domains'):
        domain_id = __salt__['pillar.get']('domains:{}:domain_id'.format(domain))
        instances = __salt__['pillar.get']('domains:{0}:fastd:instances'.format(domain), [])
        tmp.extend(["dom{0}_{1}".format(domain_id, instance['mtu']) for instance in instances])
    return tmp

#  enumerate fastd interface names for mesh-announce
def ifnames_for_domain(domain):
    domain_id = __salt__['pillar.get']('domains:{}:domain_id'.format(domain))
    instances = __salt__['pillar.get']('domains:{}:fastd:instances'.format(domain), [])
    return ["dom{0}-vpn-{1}".format(domain_id, instance['mtu']) for instance in instances]

# enumerate ports to open up in ferm
def ports_for_domain(domain):
    instances = __salt__['pillar.get']('domains:{}:fastd:instances'.format(domain), [])
    return [str(instance['port']) for instance in instances]
