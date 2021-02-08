---

/etc/apt/sources.list.d/bullseye.list:
  file.managed:
    - contents: |
        deb http://deb.debian.org/debian/ bullseye main
        deb-src http://deb.debian.org/debian/ bullseye main

        #deb http://security.debian.org/debian-security bullseye-security main
        #deb-src http://security.debian.org/debian-security bullseye-security main

/etc/apt/preferences.d/bullseye:
  file.managed:
    - contents: |
        Package: *
        Pin: release n=bullseye
        Pin-Priority: -1
