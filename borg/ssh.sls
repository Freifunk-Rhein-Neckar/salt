---

{% set backup_key_file = "/root/.ssh/id_ed25519_borgbackup" %}

create ssh key:
  cmd.run:
    - name: 'ssh-keygen -q -t ed25519 -C "{{ salt.grains.get('id') }} (borgbackup key)" -f {{ backup_key_file }} -N ""'
    - creates: {{ backup_key_file }}

pub ssh key:
  cmd.wait:
    - name: "salt-call mine.send id_ed25519_borgbackup.pub mine_function=ssh.user_keys user=root pubfile={{ backup_key_file }}.pub prvfile=False"
    - watch:
      - cmd: create ssh key

include:
  - openssh.known_hosts
