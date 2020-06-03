---
fastd:
  pkg.installed

/opt/ff-tools/fastd-statistics.py:
  file.managed:
    - source: salt://fastd/files/fastd-statistics.py
    - makedirs: True
    - mode: 755


chmod 777 /var/run/fastd.sock:
  cron.present:
    - identifier: set rights for fastd.sock
    - user: root
    # - minute: *
    - commented: False

