---
packages_base:
  pkg.installed:
    - pkgs:
      - bash-completion
      - ca-certificates
      - curl
      - debian-goodies
      - dnsutils
      - ethtool
      - fd-find
      - htop
      - iputils-arping
      - iputils-tracepath
      - lsb-release
      - lsof
      - mlocate
      - mtr-tiny
      - ncdu
      - ncurses-term
      - needrestart
      - netcat-openbsd
      - psmisc
      - python3-pip
{% if grains['oscodename'] == "buster" %}
      - ripgrep
{% endif %}
      - rsync
      - screen
{%- if salt['hardware.is_physical']() %}
      - smartmontools
      - nvme-cli
{%- endif %}
      - strace
      - tcpdump
      - tig
      - tmux
      - tree
      - tshark
      - vim
      - wget
      - whois


# these installs have dedicted states and files, so they can be referenced in require statements
include:
  - .git
