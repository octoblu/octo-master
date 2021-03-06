meshblu  = require 'meshblu'
debug    = require('debug')('octo-master:connector')
{Plugin} = require './index'

Connector = (config) ->
  conx = meshblu.createConnection
    server : config.server
    port   : config.port
    uuid   : config.uuid
    token  : config.token
    options:
      transports: ['websocket']

  consoleError = (error) ->
    console.error error
    console.error error.message
    console.error error.stack

  process.on 'uncaughtException', consoleError
  conx.on 'notReady', consoleError
  conx.on 'error', consoleError
  conx.on 'disconnect', =>
    debug 'disconnect', arguments

  plugin = new Plugin();

  conx.on 'ready', (me) ->
    debug 'ready', me
    conx.whoami uuid: config.uuid, (device) ->
      plugin.setOptions device.options
      conx.update
        uuid:          config.uuid,
        token:         config.token,
        messageSchema: plugin.messageSchema,
        optionsSchema: plugin.optionsSchema,
        options:       plugin.options

  conx.on 'message', ->
    try
      plugin.onMessage arguments...
    catch error
      consoleError error

  conx.on 'config', ->
    try
      plugin.onConfig arguments...
    catch error
      consoleError error

  plugin.on 'message', (message) ->
    conx.message message

  plugin.on 'error', consoleError

module.exports = Connector;
