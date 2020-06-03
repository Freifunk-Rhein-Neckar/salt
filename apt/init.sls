---

{% set oscodename = grains['oscodename'] %}

/etc/apt/sources.list:
  file.managed:
    - contents: |
{%- if salt['hardware.is_physical']() %}
        deb http://deb.debian.org/debian {{ oscodename }} main contrib non-free
{%- else %}
        deb http://deb.debian.org/debian {{ oscodename }} main
{%- endif %}
        deb-src http://deb.debian.org/debian {{ oscodename }} main
{% if salt['hardware.is_physical']() %}
        deb http://deb.debian.org/debian {{ oscodename }}-updates main contrib non-free
{%- else %}
        deb http://deb.debian.org/debian {{ oscodename }}-updates main
{%- endif %}
        deb-src http://deb.debian.org/debian {{ oscodename }}-updates main

        deb http://deb.debian.org/debian {{ oscodename }}-backports main
{% if salt['hardware.is_physical']() %}
        deb http://security.debian.org/debian-security {{ oscodename }}/updates main contrib non-free
        deb-src http://security.debian.org/debian-security {{ oscodename }}/updates main contrib non-free
{% else %}
        deb http://security.debian.org/debian-security {{ oscodename }}/updates main
        deb-src http://security.debian.org/debian-security {{ oscodename }}/updates main
{%- endif %}

apt-transport-https:
  pkg.installed:
    - name: apt-transport-https
