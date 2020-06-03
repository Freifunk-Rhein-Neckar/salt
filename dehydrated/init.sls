---
dehydrated dependencies:
  pkg.installed:
    - pkgs:
      - cronic
      - openssl
      - curl

/etc/dehydrated:
  git.latest:
    - name: https://github.com/dehydrated-io/dehydrated.git
    - target: /etc/dehydrated
    # - force_fetch: True
    # - force_reset: True

/var/www/dehydrated/:
  file.directory:
    - makedirs: True

dehydrated-config:
  file.managed:
    - name: /etc/dehydrated/config
    - source: salt://dehydrated/files/config.j2
    - mode: 644
    - template: jinja

dehydrated-hook-nginx:
  file.managed:
    - name: /etc/dehydrated/hook-nginx.sh
    - source: salt://dehydrated/files/hook-nginx.sh
    - mode: 744
    # - template: jinja

dehydrated-domains:
  file.managed:
    - name: /etc/dehydrated/domains.txt
    - source: salt://dehydrated/files/domains.txt.j2
    - mode: 644
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

firstinstall:
  cmd.run:
    - name: ./dehydrated --register --accept-terms
    - cwd: /etc/dehydrated/
    - creates: /etc/dehydrated/accounts
