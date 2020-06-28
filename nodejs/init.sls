---
{%- from 'nodejs/map.jinja' import nodejs with context %}

nodejs:
  pkgrepo.managed:
    - humanname: nodejs
    - name: {{ nodejs.apt_repo }}
    - key_url: salt://nodejs/files/nodesource.gpg
    - file: /etc/apt/sources.list.d/nodejs.list
    - clean_file: True
    - require_in:
      - pkg: nodejs
  pkg.installed:
    - pkgs:
      - nodejs
