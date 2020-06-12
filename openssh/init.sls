---
openssh-server:
  pkg.installed: []
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config


{% if grains['os'] == 'Debian' %}
/etc/ssh/sshd_config:
  file.append:
    - text:
      - "DebianBanner no"
{% endif %}
