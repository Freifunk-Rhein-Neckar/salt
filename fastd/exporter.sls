---
include:
  - nftables
  - golang

{% import 'nftables/macro.sls' as nftables %}
{{ nftables.include('50-fastd-exporter', 'salt://fastd/files/nftables-exporter.conf.j2' ) }}

{%- set gopath = salt['pillar.get']('golang:gopath', '/usr/local/go') %}
{%- set gopkg = 'git.darmstadt.ccc.de/ffda/fastd-exporter' %}

fastd-exporter:
  git.latest:
    - name: https://{{ gopkg }}.git
    - target: {{ gopath }}/src/{{ gopkg }}
  cmd.run:
    - cwd: {{ gopath }}/src/{{ gopkg }}
    - name: go get -v -u {{ gopkg }}
    - env:
        GOPATH: {{ salt['pillar.get']('golang:gopath', '/usr/local/go') }}
    - require:
      - pkg: golang
      - git: fastd-exporter
    - onchanges:
      - git: fastd-exporter
  service.running:
    - enable: True
    - name: fastd-exporter.service
    - watch:
      - cmd: fastd-exporter

/etc/systemd/system/fastd-exporter.service:
  file.managed:
    - source: salt://systemd/files/systemd.j2
    - user: root
    - mode: '0644'
    - template: jinja
    - context:
        config:
          - Unit:
            - Description: "Fastd Prometheus Exporter"
            - Wants: "network.target"
            - After: "network.target"
          - Service:
            - Type: "simple"
            - ExecStart: "/usr/local/go/bin/fastd-exporter -instances {{ ','.join(salt['fastd.all_instances']()) }} --metrics.perpeer"
          - Install:
            - WantedBy: "multi-user.target"
    - require_in:
      - service: fastd-exporter
    - watch_in:
      - service: fastd-exporter
