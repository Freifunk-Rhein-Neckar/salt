---
include:
  - network.sysctl.forwarding

qemu-system:
  pkg.installed:
    - install_recommends: False

qemu additional:
  pkg.installed:
    - pkgs:
      - qemu-utils
      - libvirt-clients
      - libvirt-daemon-system
    - install_recommends: False
