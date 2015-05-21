{exec} = require 'child_process'
ServiceFile = require './service-file'

class Container
  constructor: (options={}, dependencies={}) ->
    {@uuid,@token,@image} = options

  create: (image) =>
    serviceFile = new ServiceFile uuid: @uuid, token: @token, image: image
    serviceFile.open (error, filePath) =>
      return callback error if error?
      exec "fleetctl start #{filePath}", (error, stdout, stderr) =>
        console.error('exec error:', error.message) if error?
        console.log stdout
        console.error stderr
        serviceFile.close()

  createOcto: =>
    @create 'octoblu/gateblu-forever'

  delete: =>
    exec "fleetctl destroy octo-#{@uuid}.service", (error, stdout, stderr) =>
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr

module.exports = Container
