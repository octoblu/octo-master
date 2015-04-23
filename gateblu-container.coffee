class GatebluContainer
  constructor: (options={}, dependencies={}) ->
    @spawn = dependencies.spawn ? require('child_process').spawn
    {@uuid,@token} = options

  create: =>
    @sendKubeCommand 'create'

  delete: =>
    @sendKubeCommand 'stop'

  sendKubeCommand: (command) ->
    @childProcess = @spawn "kubectl.sh", [command, "-f", "-"]
    @childProcess.stdout.pipe process.stdout
    @childProcess.stderr.pipe process.stderr
    @childProcess.stdin.write JSON.stringify @controller()
    @childProcess.stdin.end()

  controller: =>
    id: "octo-#{@uuid}"
    kind: "ReplicationController"
    apiVersion: "v1beta1"
    labels:
      name: "octo-#{@uuid}"
    desiredState:
      replicas: 1
      replicaSelector:
        name: "octo-#{@uuid}"
      podTemplate:
        labels:
          name: "octo-#{@uuid}"
          app: "octo"
        desiredState:
          manifest:
            version: "v1beta1"
            id: "octo-#{@uuid}"
            containers: [
              name: "gateblu-forever"
              image: "octoblu/gateblu-forever"
              env: [
                {name: "MESHBLU_UUID", value: @uuid}
                {name: "MESHBLU_TOKEN", value: @token}
              ]
            ]

module.exports = GatebluContainer
