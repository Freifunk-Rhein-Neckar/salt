---

{% set version = '4.1.3' %}

jool:
  pkg.installed:
    - pkgs:
      - jool-dkms
      - jool-tools
{% if grains['oscodename'] == "buster" %}
    - sources:
      - jool-dkms: https://www.jool.mx/download/jool-dkms_4.1.3-1_all.deb
      - jool-tools: https://www.jool.mx/download/jool-tools_4.1.3-1_amd64.deb
#      - jool-dkms: https://github.com/NICMx/Jool/releases/download/v{{ version }}/jool-dkms_{{ version }}-1_all.deb
#      - jool-tools: https://github.com/NICMx/Jool/releases/download/v{{ version }}/jool-tools_{{ version }}-1_amd64.deb
{% endif %}
