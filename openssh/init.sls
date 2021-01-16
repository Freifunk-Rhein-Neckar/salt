---
openssh-server:
  pkg.installed: []
  service.running:
    - name: ssh
    - enable: True
    - reload: True
{% if grains['os'] == 'Debian' %}
    - watch:
      - file: /etc/ssh/sshd_config
{% endif %}

{% if grains['os'] == 'Debian' %}
/etc/ssh/sshd_config:
  file.append:
    - text:
      - "DebianBanner no"
{% endif %}
