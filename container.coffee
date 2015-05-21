{exec} = require 'child_process'
ServiceFile = require './service-file'

class GatebluContainer
  constructor: (options={}, dependencies={}) ->
    {@uuid,@token,@image} = options

  createOcto: =>
    serviceFile = new ServiceFile uuid: @uuid, token: @token, image: 'octoblu/gateblu-forever'
    serviceFile.open (error, filePath) =>
      return callback error if error?
      exec "fleetctl start #{filePath}", (error, stdout, stderr) =>
        console.error('exec error:', error.message) if error?
        console.log stdout
        console.error stderr
        serviceFile.close()

  deleteOcto: =>
    exec "fleetctl destroy octo-#{@uuid}.service", (error, stdout, stderr) =>
      console.error('exec error:', error.message) if error?
      console.log stdout
      console.error stderr

module.exports = GatebluContainer
