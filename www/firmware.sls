---
/var/www/fw:
  git.latest:
    - name: https://github.com/Freifunk-Rhein-Neckar/gluon-firmware-selector.git
    - target: /var/www/fw
    - force_fetch: True
    - force_reset: True

/var/www/fw/config.js:
  file.managed:
    - source: salt://www/files/firmware-config.js
    - mode: '0644'
    - require:
      - git: /var/www/fw


/var/www/fw/images/:
  file.directory:
    - require:
        - git: /var/www/fw

/var/www/fw/images/stable:
  file.symlink:
    - target: /var/www/fw.gluon/stable/
    - require:
      - git: /var/www/fw

/var/www/fw/images/beta:
  file.symlink:
    - target: /var/www/fw.gluon/beta/
    - require:
      - git: /var/www/fw

/var/www/fw/images/experimental:
  file.symlink:
    - target: /var/www/fw.gluon/experimental/
    - require:
      - git: /var/www/fw

/var/www/fw/images/nightly:
  file.symlink:
    - target: /var/www/fw.gluon/nightly/
    - require:
      - git: /var/www/fw