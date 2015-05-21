'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('octo-master:index')
GatebluContainer = require './gateblu-container'

MESSAGE_SCHEMA =
  type: 'object'
  properties:
    uuid:
      type: 'string'
      required: true
    token:
      type: 'string'
      required: true

OPTIONS_SCHEMA = {}

COMMANDS =
  'create-octo': 'create'
  'delete-octo': 'delete'
  'generate': 'generate'

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    debug 'onMessage', message
    {uuid,token} = message.payload
    command = COMMANDS[message.topic]

    gatebluContainer = new GatebluContainer uuid: uuid, token: token
    gatebluContainer[command]()

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
