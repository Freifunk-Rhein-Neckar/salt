---
packages_base:
  pkg.installed:
    - pkgs:
      - bash-completion
      - ca-certificates
      - curl
      - debian-goodies
      - dnsutils
{%- if salt['hardware.is_physical']() %}
      - ethtool
{%- endif %}
      - htop
      - iperf3
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
{% if grains['oscodename'] == "buster" %}
      - ripgrep
{% endif %}
      - rsync
      - screen
      - strace
      - tcpdump
      - tig
      - tmux
      - tree
      - tshark
      - vim
      - wget
      - whois

# these installs have dedicted states, so they can be referenced in require statements
git:
  pkg.installed
