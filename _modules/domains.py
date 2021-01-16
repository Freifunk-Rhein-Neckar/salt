
def pretty_names():
    domains = {}
    for domain in __salt__['pillar.get']('domains').values():
        for domain_code, domain_pretty in domain['domain_names'].items():
            try:
                domains[domain_code] = domain_pretty.decode('utf-8')
            except AttributeError:
                domains[domain_code] = domain_pretty
    return domains

def domain_codes():
    codes = []
    for domain in __salt__['pillar.get']('domains').keys():
        codes.extend(__salt__['pillar.get']('domains:%s:domain_names' % domain).keys())
    return codes

def domain_subnets():
    subnets = []
    for domain in __salt__['pillar.get']('domains').keys():
        subnets.extend(__salt__['pillar.get']('domains:%s:ip4' % domain).keys())
    return subnets

def radv_enabled(domain_key):
    host = __salt__['pillar.get']('radv:enabled', True)
    domain = __salt__['pillar.get']('domains:%s:radv:enabled' % domain_key, True)

    return host and domain
