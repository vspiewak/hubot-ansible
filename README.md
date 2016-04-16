# Hubot Script Ansible

[![Version npm](https://img.shields.io/npm/v/hubot-ansible.svg?style=flat-square)](https://www.npmjs.com/package/hubot-ansible) [![npm Downloads](https://img.shields.io/npm/dm/hubot-ansible.svg?style=flat-square)](https://www.npmjs.com/package/hubot-ansible) [![Dependencies](https://img.shields.io/david/vspiewak/hubot-ansible.svg?style=flat-square)](https://david-dm.org/vspiewak/hubot-ansible)

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


## EC2 dynamic inventory configuration

* Install hubot in /opt/hubot (or somewhere else...)
* Upload inventory/ec2.{py,ini} in /opt/hubot folder
* Upload a PEM (or ssh key) in /opt/hubot folder
* Set at least the following ENV VARS to hubot:
  - export ANSIBLE_HOST_KEY_CHECKING=False
  - export EC2_REGION=us-east-1
  - export AWS_ACCESS_KEY=`<your_aws_key>`
  - export AWS_SECRET_KEY=`<your_aws_secret>`
  - export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
  - export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
  - export HUBOT_ANSIBLE_INVENTORY_FILE=/opt/hubot/inventory/ec2.py
  - export HUBOT_ANSIBLE_PRIVATE_KEY=/opt/hubot/`<your_pem_file>`.pem
  - export HUBOT_ANSIBLE_REMOTE_USER="admin"
* chmod 400 /opt/hubot/the_pem_file.pem
* Dont forget to install ansible on hubot host !

You can *debug* launching this command as the "hubot user":

    ansible -i $HUBOT_ANSIBLE_INVENTORY_FILE --private-key=$HUBOT_ANSIBLE_PRIVATE_KEY all -u $HUBOT_ANSIBLE_REMOTE_USER -m shell -a "date"


## Contribute

Just send pull request or file an issue !


## Copyright

Copyright &copy; Vincent Spiewak. See [`LICENSE`](LICENSE) for details.
