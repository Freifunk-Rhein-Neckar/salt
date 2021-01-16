---

{% if grains['osfinger'] != 'Ubuntu-18.04' %}

fd-find:
  pkg.installed: []

{% endif %}
