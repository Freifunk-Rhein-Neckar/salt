---
packages_base:
  pkg.installed:
    - pkgs:
      - bash-completion
      - ca-certificates
      - debian-goodies
      - dnsutils
      - ethtool
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
      - zip


# these installs have dedicted states and files, so they can be referenced in require statements
include:
  - .curl
  - .fd-find
  - .git
  - .jq
  - .rsync
  - .unzip
