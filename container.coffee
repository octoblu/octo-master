{EventEmitter} = require 'events'
{exec} = require 'child_process'
ServiceFile = require './service-file'

class Container extends EventEmitter
  constructor: (options={}, dependencies={}) ->
    {@uuid,@token,@image} = options

  create: (callback=->)=>
    @delete =>
      @waitForDeath =>
        serviceFile = new ServiceFile uuid: @uuid, token: @token, image: @image
        serviceFile.open (error, filePath) =>
          return callback error if error?
          exec "fleetctl start #{filePath}", (error, stdout, stderr) =>
            @emit 'step-change', uuid: @uuid, step: 'started-flow-runner'
            console.error('exec error:', error.message) if error?
            console.log stdout
            console.error stderr
            serviceFile.close()

  delete: (callback=->) =>
    exec "fleetctl destroy octo-#{@uuid}.service", (error, stdout, stderr) =>
      @emit 'step-change', uuid: @uuid, step: 'deleted-flow-runner'
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr
      callback error

  pull: (callback=->) =>
    exec "fleetctl start global-flow-runner-update.service", (error, stdout, stderr) =>
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr
      callback error

  waitForDeath: (callback=->) =>
    child = exec "fleetctl status octo-#{@uuid}.service"
    child.on 'exit', (code) =>
      return callback() if code != 0
      @emit 'step-change', uuid: @uuid, step: 'waiting-for-flow-runner'
      _.defer @waitForDeath, callback


module.exports = Container
