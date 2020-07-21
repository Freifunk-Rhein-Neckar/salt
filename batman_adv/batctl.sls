---

{% if salt['pillar.get']('batctl:commit', False) %}
batctl_pkgs:
  pkg.installed:
    - pkgs:
      - git
      - libnl-3-dev
      - libnl-genl-3-dev
      - checkinstall

batctl:
  cmd.script:
    - name: salt://batman_adv/files/mkbatctl.j2
    - template: jinja
    - shell: /bin/bash
    - unless: "[ \"$(batctl -v | awk '{ print $2 }')\" = \"{{ pillar.batctl.version }}\" ]"
    - require:
      - pkg: batctl_pkgs

{% else %}

batctl:
  pkg.installed:
    - fromrepo: {{ grains['oscodename'] }}-backports

/etc/apt/preferences.d/backports-batctl:
  file.managed:
    - contents: |
        Package: batctl
        Pin: release n={{ grains['oscodename'] }}-backports
        Pin-Priority: 900

{% endif %}
