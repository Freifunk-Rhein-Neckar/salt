---

openssh-server:
  pkg.installed: []
  service.running:
    - name: ssh
    - enable: True
    - reload: True

{% if grains['osfullname'] == "Debian" and grains['osmajorrelease'] >= 11 %}

/etc/ssh/sshd_config:
  file.append:
    - text:
      - "Include /etc/ssh/sshd_config.d/*.conf"
    - watch_in:
      - service: openssh-server

/etc/ssh/sshd_config.d/:
  file.directory:
    - dir_mode: '0755'
    - makedirs: True
    - require:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config

{% if grains['os'] == 'Debian' %}
/etc/ssh/sshd_config.d/DebianBanner.conf:
  file.managed:
    - contents:
      - "DebianBanner no"
    - require:
      - file: /etc/ssh/sshd_config.d/
    - watch_in:
      - service: openssh-server
{% endif %}

{% endif %}
