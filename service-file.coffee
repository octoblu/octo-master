os = require 'os'
path = require 'path'
fs = require 'fs-extra'
eco = require 'eco'

SERVICE_TEMPLATE = eco.compile fs.readFileSync(path.join(__dirname, 'octo.service.eco'), 'utf8')

class ServiceFile
  constructor: (options={}) ->
    {@uuid, @token, @image} = options
    @servicesPath = path.join os.tmpdir(), 'services'
    @filePath = path.join @servicesPath, "octo-#{@uuid}.service"

  open: (callback=->) =>
    fs.mkdirp @servicesPath, (error) =>
      return callback error if error?

      data = SERVICE_TEMPLATE uuid: @uuid, token: @token, image: @image
      fs.writeFile @filePath, data, encoding: 'utf8', (error) =>
        return callback error if error?
        callback null, @filePath

  close: (callback=->) =>
    fs.remove @filePath, (error) =>
      return callback error if error?
      callback()

module.exports = ServiceFile
