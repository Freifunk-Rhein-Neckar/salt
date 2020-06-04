---
dehydrated dependencies:
  pkg.installed:
    - pkgs:
      - cronic
      - openssl
      - curl
      - knot-dnsutils

/etc/dehydrated:
  git.latest:
    - name: https://github.com/dehydrated-io/dehydrated.git
    - target: /etc/dehydrated

/var/www/dehydrated/:
  file.directory:
    - makedirs: True

/etc/dehydrated/config:
  file.managed:
    - source: salt://dehydrated/files/config.j2
    - mode: '0640'
    - template: jinja

/etc/dehydrated/hook.sh:
  file.managed:
    - source: salt://dehydrated/files/hook.sh.j2
    - mode: '0740'
    - template: jinja

/etc/dehydrated/domains.txt:
  file.managed:
    - source: salt://dehydrated/files/domains.txt.j2
    - mode: '0640'
    - template: jinja

dehydrated-cron:
  cron.present:
    - name: cronic /etc/dehydrated/dehydrated -c
    - user: root
    - identifier: dehydrated-cron
    - minute: 21
    - hour: 5
    - daymonth: '*/3'
    - comment: Renew TLS certificates

first-install:
  cmd.run:
    - name: ./dehydrated --register --accept-terms
    - cwd: /etc/dehydrated/
    - creates: /etc/dehydrated/accounts

/etc/dehydrated/dehydrated --account:
  cmd.run:
    - onchanges:
      - file: /etc/dehydrated/config

/etc/dehydrated/dehydrated --cron:
  cmd.run:
    - onchanges:
      - file: /etc/dehydrated/domains.txt
