# Hubot Script Ansible

## Description

A hubot script for launching ansible commands

See [`src/scripts/ansible.coffee`](src/scripts/ansible.coffee) for full documentation.


## Installation

In hubot project repo, run:

`npm install hubot-ansible --save`

Then add **hubot-ansible** to your `external-scripts.json`:

```json
[
  "hubot-ansible"
]
```


## Configuration

hubot-ansible can use [`hubot-auth`](https://github.com/hubot-scripts/hubot-auth) for restrict usage to certains roles.

hobot-ansible use slack-attachment for nice integration with Slack.


## Sample Interaction

```
vspiewak> Hubot ansible webserver date
Hubot> admin@webserver: date
173.194.45.83 | success | rc=0 >>
Sun Nov  8 11:27:55 CET 2015

vspiewak> Hubot ansible-sudo webserver /etc/init.d/ntp restart
Hubot> admin@webserver: sudo /etc/init.d/ntp restart
173.194.45.83 | success | rc=0 >>
Restarting ntp (via systemctl): ntp.service.

vspiewak> Hubot ansible-as go gocd ps
Hubot> admin@gocd: sudo -iu go ps
173.194.45.83 | success | rc=0 >>
 PID TTY          TIME CMD
30912 pts/0    00:00:00 sh
30913 pts/0    00:00:00 python
30914 pts/0    00:00:00 sh
30915 pts/0    00:00:00 ps
```


## Contribute

Just send pull request or file an issue !


## Copyright

Copyright &copy; Vincent Spiewak. See [`LICENSE`](LICENSE) for details.
