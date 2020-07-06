---
/etc/telegraf/telegraf.d/jitsi.conf:
  file.managed:
    - source: salt://jitsi-meet/files/jitsi.telegraf.conf
    - user: root
    - group: root
    - mode: '0744'
    - watch_in:
      - service: telegraf/service/running

jvb/config/JVB_OPTS:
  file.replace:
    - name: /etc/jitsi/videobridge/config
    - pattern: '^JVB_OPTS=(.*)$'
    - repl: 'JVB_OPTS="--apis=rest,"'
    - count: 1
    - append_if_not_found: True
    - watch_in:
      - service: jitsi-videobridge2

jvb/sip-communicator.properties/ENABLE_STATISTICS:
  file.replace:
    - name: /etc/jitsi/videobridge/sip-communicator.properties
    - pattern: '^org.jitsi.videobridge.ENABLE_STATISTICS=(.*)$'
    - repl: 'org.jitsi.videobridge.ENABLE_STATISTICS=true'
    - count: 1
    - append_if_not_found: True
    - watch_in:
      - service: jitsi-videobridge2

jvb/sip-communicator.properties/STATISTICS_TRANSPORT:
  file.replace:
    - name: /etc/jitsi/videobridge/sip-communicator.properties
    - pattern: '^org.jitsi.videobridge.STATISTICS_TRANSPORT=(.*)$'
    - repl: 'org.jitsi.videobridge.STATISTICS_TRANSPORT=muc,colibri'
    - count: 1
    - append_if_not_found: True
    - watch_in:
      - service: jitsi-videobridge2

jvb/sip-communicator.properties/STATISTICS_INTERVAL:
  file.replace:
    - name: /etc/jitsi/videobridge/sip-communicator.properties
    - pattern: '^org.jitsi.videobridge.STATISTICS_INTERVAL=(.*)$'
    - repl: 'org.jitsi.videobridge.STATISTICS_INTERVAL=5000'
    - count: 1
    - append_if_not_found: True
    - watch_in:
      - service: jitsi-videobridge2
