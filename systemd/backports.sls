---

/etc/apt/preferences.d/backports-systemd:
  file.managed:
    - contents: |
        Package: systemd libzstd1 libsystemd0 udev libudev1
        Pin: release n={{ grains['oscodename'] }}-backports
        Pin-Priority: 900

systemd:
  pkg.installed:
    - fromrepo: {{ grains['oscodename'] }}-backports
