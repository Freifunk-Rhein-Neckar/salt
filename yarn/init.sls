---
yarn:
  pkgrepo.managed:
    - humanname: yarn
    - name: deb https://dl.yarnpkg.com/debian stable main
    - key_url: salt://yarn/files/yarn.gpg
    - file: /etc/apt/sources.list.d/yarn.list
    - clean_file: True
    - require_in:
      - pkg: yarn
  pkg.installed:
    - pkgs:
      - yarn
