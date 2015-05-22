{exec} = require 'child_process'
ServiceFile = require './service-file'

class Container
  constructor: (options={}, dependencies={}) ->
    {@uuid,@token,@image} = options

  create: =>
    @delete =>
      @waitForDeath =>
        serviceFile = new ServiceFile uuid: @uuid, token: @token, image: @image
        serviceFile.open (error, filePath) =>
          return callback error if error?
          exec "fleetctl start #{filePath}", (error, stdout, stderr) =>
            console.error('exec error:', error.message) if error?
            console.log stdout
            console.error stderr
            serviceFile.close()

  delete: (callback=->) =>
    exec "fleetctl destroy octo-#{@uuid}.service", (error, stdout, stderr) =>
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr
      callback error

  pull: (callback=->) =>
    exec "docker pull #{@image}", (error, stdout, stderr) =>
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr
      callback error

  waitForDeath: (callback=->) =>
    child = exec "fleetctl status octo-#{@uuid}.service"
    child.on 'exit', (code) =>
      return callback() if code != 0
      _.defer @waitForDeath, callback


module.exports = Container
