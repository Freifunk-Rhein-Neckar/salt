---
# Create authorized_keys File for the Backup Server

/root/backup-authorized_keys:
  file.managed:
    - source: salt://borg/files/authorized_keys.j2
    - user: root
    - group: root
    - mode: '0600'
    - makedirs: True
    - template: jinja
