---
resolv-file:
  file.managed:
  - name: /etc/resolv.conf
  # - mode: '0644'
  - source: salt://common/files/resolv.conf.j2
  - template: jinja
  - defaults:
      nameservers: {{ salt['pillar.get']('resolver:nameservers', ['46.182.19.48','2a02:2970:1002::18', '1.1.1.1']) }}
      searchpaths: {{ salt['pillar.get']('resolver:searchpaths', [salt['grains.get']('domain'),]) }}
      domain: {{ salt['pillar.get']('resolver:domain', salt['grains.get']('domain')) }}
