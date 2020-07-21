---
{%- if salt['pillar.get']('batman_adv:commit', False) %}

# include:
#   - common.kernel

# build kmod from git when commit is given

batman-adv_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - dkms
      - build-essential
      - pkg-config

batman-adv_git:
  git.latest:
    - name: {{ pillar.batman_adv.remote }}
    - target: /usr/src/batman-adv-{{ pillar.batman_adv.version }}
    - rev: {{ pillar.batman_adv.commit }}
    - force_reset: True
    - require:
      - pkg: batman-adv_pkgs

/usr/src/batman-adv-{{ pillar.batman_adv.version }}/dkms.conf:
  file.managed:
    - source: salt://batman_adv/files/dkms.conf.j2
    - template: jinja
    - require:
      - git: batman-adv_git

batman-adv_dkms_add:
  cmd.run:
    - onchanges:
      - git: batman-adv_git
    - require:
      - pkg: linux-kernel
      - pkg: batman-adv_pkgs
      - file: /usr/src/batman-adv-{{ pillar.batman_adv.version }}/dkms.conf
    - name: dkms add -m batman-adv -v {{ pillar.batman_adv.version }}

batman-adv_dkms_build:
  cmd.run:
    - onchanges:
      - cmd: batman-adv_dkms_add
    - name: dkms build -m batman-adv -v {{ pillar.batman_adv.version }}

batman-adv_dkms_install:
  cmd.run:
    - onchanges:
      - cmd: batman-adv_dkms_build
    - name: dkms install -m batman-adv -v {{ pillar.batman_adv.version }} --force

{%- else %}

# else remove kmod and return to intree version

batman-adv_dkms_remove:
  cmd.run:
    - name: dkms remove batman_adv --all

{%- endif %}

# either way, make sure the module is loaded on boot

batman_adv:
  kmod.present:
    - persist: True
