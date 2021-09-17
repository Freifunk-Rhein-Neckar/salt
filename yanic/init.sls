---
{% import 'nftables/macro.sls' as nftables %}
{%- set gopath = '/var/lib/yanic/go' %}
{%- set gocache = '/var/lib/yanic/.cache/go' %}

include:
  - golang
  - nftables
  - systemd.daemon-reload

yanic:
  user.present:
    - home: /var/lib/yanic
    - usergroup: True
    - shell: /usr/sbin/nologin
  git.latest:
    - name: https://github.com/FreifunkBremen/yanic
    - target: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - force_fetch: True
    - force_reset: True
    - rev: HEAD
    - refspec_branch: main
    - user: yanic
    - require:
      - user: yanic
      - file: /var/lib/yanic
  cmd.run:
    - cwd: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - name: go get -v -u github.com/FreifunkBremen/yanic
    - user: yanic
    - env:
        GOPATH: {{ gopath }}
        GOCACHE: {{ gocache }}
    - require:
      - pkg: golang
      - git: yanic
      - file: /var/lib/yanic
      - file: {{ gocache }}
    - onchanges:
      - git: yanic
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/yanic.service
      - file: /etc/yanic/config.toml
      - file: /var/lib/yanic
      - cmd: yanic

/var/lib/yanic:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: '0774'
    - require:
      - user: yanic

{{ gocache }}:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: '0774'
    - makedirs: True
    - require:
      - user: yanic
      - file: /var/lib/yanic

/var/www/data:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: '0775'
    - require:
      - user: yanic

/var/log/yanic:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: '2750'
    - require:
      - user: yanic

/etc/yanic:
  file.directory:
    - user: root
    - group: yanic
    - dir_mode: '0755'

/etc/yanic/config.toml:
  file.managed:
    - source: salt://yanic/files/yanic.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - file: /etc/yanic

/var/lib/yanic/state:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: '0755'
    - require:
      - file: /var/lib/yanic

{{ nftables.include('40-yanic', 'salt://yanic/files/nftabels.conf.j2' ) }}

/etc/systemd/system/yanic.service:
  file.managed:
    - source: salt://yanic/files/yanic.service
    - user: root
    - group: root
    - mode: '0644'
    - onchanges_in:
      - cmd: systemctl daemon-reload
