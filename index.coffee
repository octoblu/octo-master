'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('octo-master:index')
Container = require './container'

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
  'create': 'create'
  'delete': 'delete'
  'generate': 'generate'

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    debug 'onMessage', message
    {uuid,token,image} = message.payload
    command = COMMANDS[message.topic]

    gatebluContainer = new Container uuid: uuid, token: token, image: image
    gatebluContainer[command]()

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
