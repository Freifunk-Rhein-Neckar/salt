---
# ifupd_ensure_include:
#   file.append:
#     - name: /etc/network/interfaces
#     - text: |
#         source /etc/network/interfaces.d/*.cfg

/etc/network/interfaces.d:
  file.directory: []

# ifupd_ensure_exclude:
#   file.uncomment:
#     - name: /etc/network/interfaces
#     - regex: "^source"
