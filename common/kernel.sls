/etc/apt/preferences.d/backports-kernel:
{% if salt['pillar.get']('kernel_backports', True) %}
  file.managed:
    - source: salt://common/files/backports-kernel
    - template: jinja
    - watch_in:
      - pkg: linux-kernel
    - require_in:
      - pkg: linux-kernel
{% else %}
  file.absent
{% endif %}

linux-kernel:
  pkg.installed:
    - pkgs:
      - linux-image-amd64
      - linux-headers-amd64
      - iproute2
