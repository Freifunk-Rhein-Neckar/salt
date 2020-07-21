---
{% import 'nftables/macro.sls' as nftables %}
{% set domain = "meet.ffrn.de" %}

{{ nftables.include('40-jitsi-meet', 'salt://jitsi-meet/files/nftables.conf.j2' ) }}

jitsi-videobridge2:
  service.running:
    - enable: True


/usr/share/jitsi-meet/interface_config.js:
  file.managed:
    - source: salt://jitsi-meet/files/interface_config.js.j2
    - user: root
    - group: root
    - template: jinja
    - mode: '0644'

/etc/jitsi/meet/{{ domain }}-config.js:
  file.managed:
    - source: salt://jitsi-meet/files/config.js.j2
    - user: root
    - group: root
    - template: jinja
    - mode: '0644'
    - context:
        domain: {{ domain }}


include:
  - .statistics
