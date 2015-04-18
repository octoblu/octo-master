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

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    {uuid,token} = message.payload

    gatebluContainer = new GatebluContainer uuid: uuid, token: token
    gatebluContainer.start()

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options

module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
