try
  meshbluJSON  = require './meshblu.json'
catch
  meshbluJSON =
    uuid:   process.env.MESHBLU_DEVICE_UUID
    token:  process.env.MESHBLU_DEVICE_TOKEN
    server: process.env.MESHBLU_HOST
    port:   process.env.MESHBLU_PORT
    name:   'Google Authenticator'

Connector = require './connector'

new Connector meshbluJSON
