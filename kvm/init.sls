---
qemu-kvm:
  pkg.installed: []

qemu additional:
  pkg.installed:
    - pkgs:
      - qemu-utils
      - libvirt-clients
