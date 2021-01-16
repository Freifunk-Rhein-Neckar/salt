---

/root/.ssh/authorized_keys:
  file.managed:
    - source: salt://openssh/files/authorized_keys.j2
    - user: root
    - group: root
    - mode: '0600'
    - makedirs: True
    - template: jinja
