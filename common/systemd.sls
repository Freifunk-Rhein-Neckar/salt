---

systemd_pkgs:
  pkg.installed:
    - pkgs:
      - dbus
      - libpam-systemd
      - systemd-coredump
