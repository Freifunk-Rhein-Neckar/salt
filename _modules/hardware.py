
def is_physical():
    virtual = __salt__['grains.get']('virtual')

    if virtual == 'physical':
        return True
    elif virtual == 'xen':
        virtual_subtype = __salt__['grains.get']('virtual_subtype')
        return virtual_subtype == 'Xen Dom0'
    elif virtual in ['kvm', 'qemu', 'LXC']:
        return False

    raise ValueError(
        "hardware.is_physical: unhandled virtual type '{}'.".format(virtual))

def microcode_package():
    cpu_model = __salt__['grains.get']('cpu_model')

    if 'AMD' in cpu_model:
        return ['amd64-microcode']
    elif 'Intel(R)' in cpu_model:
        return ['intel-microcode']

    return []
