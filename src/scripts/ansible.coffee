# Description:
#   A hubot script for launching ansible commands
#
# Dependencies:
#   "shelljs": ">= 0.5.3"
#
# Configuration:
#   HUBOT_ANSIBLE_INVENTORY_FILE - The inventory file
#   HUBOT_ANSIBLE_PRIVATE_KEY - The private key file
#   HUBOT_ANSIBLE_PREFIX_HOSTS - Prefix ansible hosts
#   HUBOT_ANSIBLE_REMOTE_USER - Remote user
#   HUBOT_ANSIBLE_AUTHORIZED_ROLES - Restrict users with a list of authorized roles (need to install hubot-auth)
#
# Commands:
#   hubot ansible <host> <command> - Execute the command on the hosts
#   hubot ansible-sudo <host> <command> - Execute the command on the hosts sudoing to root
#   hubot ansible-as <user> <host> <command> - Execute the command on the hosts sudoing to <user>
#
# Author:
#   vspiewak

inventory =  process.env.HUBOT_ANSIBLE_INVENTORY_FILE
private_key = process.env.HUBOT_ANSIBLE_PRIVATE_KEY
remote_user = process.env.HUBOT_ANSIBLE_REMOTE_USER
prefix_hosts = process.env.HUBOT_ANSIBLE_PREFIX_HOSTS ?= ""
authorized_roles = process.env.HUBOT_ANSIBLE_AUTHORIZED_ROLES

missingEnvironment = (msg) ->
    missingAnything = false
    unless inventory?
      msg.send "You need to set HUBOT_ANSIBLE_INVENTORY_FILE"
      missingAnything |= true
    unless private_key?
      msg.send "You need to set HUBOT_ANSIBLE_PRIVATE_KEY"
      missingAnything |= true
    unless remote_user?
      msg.send "You need to set HUBOT_ANSIBLE_REMOTE_USER"
      missingAnything |= true
    missingAnything

has_an_authorized_role = (robot, user) ->
  for r in robot.auth.userRoles user
    return true if r in authorized_roles.split(',')
  return false

is_authorized = (robot, user, res) ->
  has_hubot_auth = robot.auth? and robot.auth.hasRole?
  must_restrict_with_roles = has_hubot_auth and authorized_roles?
  (not must_restrict_with_roles) or has_an_authorized_role robot, user

display_result = (robot, res, hosts, user, command, text) ->
  if robot.adapterName != "slack"
    res.reply "#{user}@#{hosts.slice prefix_hosts.length}: #{command}\n#{text}"
  else
    robot.emit 'slack-attachment',
      channel: "#{res.message.user.room}"
      content:
        color: "#55acee"
        fallback: "#{text}"
        title: "#{user}@#{hosts.slice prefix_hosts.length}: #{command}"
        text: "#{text}"

run_ansible = (robot, hosts, remote_user, command, res) ->
  shell = require('shelljs')
  ansible = "ansible -i #{inventory} --private-key=#{private_key} #{hosts} -u #{remote_user} -m shell -a \"#{command}\""
  shell.exec ansible, {async:true}, (code, output) ->
    display_result robot, res, hosts, remote_user, command, output

run_ansible_sudo = (robot, hosts, remote_user, command, res) ->
  shell = require('shelljs')
  ansible = "ansible -i #{inventory} --private-key=#{private_key} #{hosts} -u #{remote_user} -m shell -a \"#{command}\" --sudo"
  shell.exec ansible, {async:true}, (code, output) ->
    display_result robot, res, hosts, remote_user, "sudo #{command}", output

run_ansible_as = (robot, hosts, remote_user, user, command, res) ->
  shell = require('shelljs')
  ansible = "ansible -i #{inventory} --private-key=#{private_key} #{hosts} -u #{remote_user} -m shell -a \"#{command}\" --sudo --sudo-user #{user}"
  shell.exec ansible, {async:true}, (code, output) ->
    display_result robot, res, hosts, remote_user, "sudo -iu #{user} #{command}", output

module.exports = (robot) ->

  robot.respond /ansible\s+([\w-.]+)\s+(.+)/i, (res) ->
    hosts = res.match[1].trim()
    command = res.match[2].trim()
    authorized = is_authorized robot, res.envelope.user, res

    unless hosts == "all"
      hosts = "#{prefix_hosts}#{hosts}"

    unless authorized
      res.reply "I can't do that, you need at least one of these roles: #{authorized_roles}"

    unless (missingEnvironment res) or (not remote_user?) or (not authorized)
      run_ansible robot, hosts, remote_user, command, res

  robot.respond /ansible-sudo\s+([\w-.]+)\s+(.+)/i, (res) ->
    hosts = res.match[1].trim()
    command = res.match[2].trim()
    authorized = is_authorized robot, res.envelope.user, res

    unless hosts == "all"
      hosts = "#{prefix_hosts}#{hosts}"

    unless authorized
      res.reply "I can't do that, you need at least one of these roles: #{authorized_roles}"

    unless (missingEnvironment res) or (not remote_user?) or (not authorized)
      run_ansible_sudo robot, hosts, remote_user, command, res

  robot.respond /ansible-as\s+([\w-.]+)\s+([\w-.]+)\s+(.+)/i, (res) ->
    user = res.match[1].trim()
    hosts = res.match[2].trim()
    command = res.match[3].trim()
    authorized = is_authorized robot, res.envelope.user, res

    unless hosts == "all"
      hosts = "#{prefix_hosts}#{hosts}"

    unless authorized
      res.reply "I can't do that, you need at least one of these roles: #{authorized_roles}"

    unless (missingEnvironment res) or (not remote_user?) or (not authorized)
      run_ansible_as robot, hosts, remote_user, user, command, res
