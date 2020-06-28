---
include:
  - nodejs
  - yarn

meshviewer:
  user.present:
    - shell: /usr/sbin/nologin

/home/meshviewer/meshviewer.git:
  git.latest:
    - name: {{ salt['pillar.get']('meshviewer:repo', 'https://github.com/ffrgb/meshviewer.git') }}
    - target: /home/meshviewer/meshviewer.git
    - user: meshviewer
    - force_fetch: True
    - force_reset: True
    - refspec_branch: {{ salt['pillar.get']('meshviewer:branch', 'develop') }}
    - rev: {{ salt['pillar.get']('meshviewer:rev', 'HEAD') }}
    - require:
      - pkg: nodejs
      - user: meshviewer

/home/meshviewer/meshviewer.git/config.js:
  file.managed:
    - user: meshviewer
    - source: salt://meshviewer/files/config.js.j2
    - template: jinja
    - require:
      - git: /home/meshviewer/meshviewer.git

/home/meshviewer/meshviewer.git/scss/custom/_variables.scss:
  file.managed:
    - user: meshviewer
    - source: salt://meshviewer/files/variables.scss
    - require:
      - git: /home/meshviewer/meshviewer.git

/home/meshviewer/meshviewer.git/assets/favicon/site.webmanifest:
  file.managed:
    - user: meshviewer
    - source: salt://meshviewer/files/site.webmanifest
    - require:
      - git: /home/meshviewer/meshviewer.git

meshviewer_dependencies:
  cmd.run:
    - name: yarn
    - cwd: /home/meshviewer/meshviewer.git
    - runas: meshviewer
    - onchanges:
      - git: /home/meshviewer/meshviewer.git
      - file: /home/meshviewer/meshviewer.git/config.js
      - file: /home/meshviewer/meshviewer.git/scss/custom/_variables.scss
      - file: /home/meshviewer/meshviewer.git/assets/favicon/site.webmanifest
    - require:
      - pkg: yarn

meshviewer_remove_build:
  file.absent:
    - name: /home/meshviewer/meshviewer.git/build

meshviewer_build:
  cmd.run:
    - name: yarn run gulp
    - cwd: /home/meshviewer/meshviewer.git
    - runas: meshviewer
    - onchanges:
      - cmd: meshviewer_dependencies
    - require:
      - file: meshviewer_remove_build

# deploy
meshviewer_empty_srv_www:
   file.directory:
    - name: /var/www/meshviewer
    - makedirs: True
    - clean: True
    - onchanges:
      - cmd: meshviewer_build

/var/www/meshviewer:
  cmd.run:
    - name: cp -a /home/meshviewer/meshviewer.git/build/* /var/www/meshviewer
    - onchanges:
      - file: meshviewer_empty_srv_www
  file.directory:
    - user: www-data
    - group: www-data
    - recurse:
      - user
      - group
    - onchanges:
      - cmd: /var/www/meshviewer

# ignore some changes, allows clean git.latest with changes in those files
/home/meshviewer/meshviewer.git/.git/info/exclude:
  file.append:
    - text: 
      - config.js
      - scss/custom/_variables.scss
      - assets/favicon/site.webmanifest
    - require:
      - git: /home/meshviewer/meshviewer.git

meshviewer_git_update_index:
  cmd.run:
    - names:
      - git update-index --skip-worktree config.js
      - git update-index --skip-worktree scss/custom/_variables.scss
      - git update-index --skip-worktree assets/favicon/site.webmanifest
    - cwd: /home/meshviewer/meshviewer.git/
    - runas: meshviewer
    - onchanges:
      - file: /home/meshviewer/meshviewer.git/.git/info/exclude
