---
{%- set gopath = '/var/lib/yanic/go' %}

include:
  - golang

yanic:
  user.present:
    - home: /var/lib/yanic
    - gid: yanic
    - usergroup: True
    - shell: /usr/sbin/nologin
  git.latest:
    - name: https://github.com/FreifunkBremen/yanic
    - target: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - force_fetch: True
    - force_reset: True
    - refspec_branch: master
    - user: yanic
    - require:
      - user: yanic
  cmd.run:
    - cwd: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - name: go get -v -u github.com/FreifunkBremen/yanic
    - user: yanic
    - env:
        GOPATH: {{ gopath }}
    - require:
      - pkg: golang
      - git: yanic
    - onchanges:
      - git: yanic
  service.running:
    - enable: True
    - watch:
      - file: /etc/systemd/system/yanic.service
      - file: /etc/yanic/config.toml
      - cmd: yanic

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

/etc/systemd/system/yanic.service:
  file.managed:
    - source: salt://yanic/files/yanic.service
    - user: root
    - group: root
    - mode: '0644'
