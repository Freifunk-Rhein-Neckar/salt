---
include:
  - systemd.daemon-reload
  - common.packages.git

/var/lib/fastd/peer_groups:
  file.directory:
    - makedirs: True

{% for group_name, group in salt['pillar.get']('fastd:peer_groups').items() %}

/root/.ssh/id_fastdkeys_{{ group_name }}:
  file.managed:
    - contents: |
        {{ group.PrivateKey | indent(8) }}
    - user: root
    - group: root
    - mode: '0600'
    - makedirs: True

/var/lib/fastd/peer_groups/{{ group_name }}:
  git.latest:
    - name: {{ group['git_remote'] }}
    - rev: {{ group['git_branch'] }}
    - target: /var/lib/fastd/peer_groups/{{ group_name }}
    - identity: /root/.ssh/id_fastdkeys_{{ group_name }}
    - require:
      - pkg: git
      - file: /root/.ssh/id_fastdkeys_{{ group_name }}
      - file: /var/lib/fastd/peer_groups

{{ group_name }}_git.config:
  git.config_set:
    - name: "core.sshCommand"
    - value: "/usr/bin/ssh -i /root/.ssh/id_fastdkeys_{{ group_name }}"
    - repo: /var/lib/fastd/peer_groups/{{ group_name }}
    - require:
      - git: /var/lib/fastd/peer_groups/{{ group_name }}

/etc/systemd/system/fastd-peergroup-{{ group_name }}.service:
  file.managed:
    - source: salt://fastd/files/fastd-peergroup.service.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        group: {{ group_name }}
    - require:
      - file: /usr/local/sbin/fastd-peergroup-update-{{ group_name }}

/etc/systemd/system/fastd-peergroup-{{ group_name }}.timer:
  file.managed:
    - source: salt://fastd/files/fastd-peergroup.timer.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        group: {{ group_name }}
    - onchanges_in:
      - cmd: systemctl daemon-reload

fastd-peergroup-{{ group_name }}.timer:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/fastd-peergroup-{{ group_name }}.service
      - file: /etc/systemd/system/fastd-peergroup-{{ group_name }}.timer
    - watch:
      - file: /etc/systemd/system/fastd-peergroup-{{ group_name }}.timer

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
