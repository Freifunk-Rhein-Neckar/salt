---
/var/lib/fastd/peer_groups:
  file.directory:
    - makedirs: True

{% for group_name, group in salt['pillar.get']('fastd:peer_groups').items() %}


# Host git.ffrn.de
#     Hostname git.ffrn.de
#     IdentityFile ~/.ssh/id_ed25519-fastdkeys-v0
#     IdentitiesOnly yes


/var/lib/fastd/peer_groups/{{ group_name }}:
  git.latest:
  - name: {{ group['git_remote'] }}
  - rev: {{ group['git_branch'] }}
  - target: /var/lib/fastd/peer_groups/{{ group_name }}
  - require:
    - pkg: git
    - file: /var/lib/fastd/peer_groups

/etc/systemd/system/fastd-peergroup-{{ group_name }}.service:
  file.managed:
  - source: salt://fastd/files/fastd-peergroup.service.j2
  - user: root
  - group: root
  - mode: '0644'
  - template: jinja
  - context:
      group: {{ group_name }}

/etc/systemd/system/fastd-peergroup-{{ group_name }}.timer:
  file.managed:
  - source: salt://fastd/files/fastd-peergroup.timer.j2
  - user: root
  - group: root
  - mode: '0644'
  - template: jinja
  - context:
      group: {{ group_name }}

fastd-peergroup-{{ group_name }}.timer:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/fastd-peergroup-{{ group_name }}.service

/usr/local/sbin/fastd-peergroup-update-{{ group_name }}:
  file.managed:
  - source: salt://fastd/files/fastd-peergroup-update.j2
  - user: root
  - group: root
  - mode: '0755'
  - template: jinja
  - context:
      group: {{ group_name }}
{% endfor %}
