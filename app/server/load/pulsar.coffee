Pulsar = require "pulsar"
createServer = require './createServer'

throw new Error 'hey man'

port = process.env.GURU_PULSAR_PORT or config.app.pulsarPort

unless port is 'DISABLED'
  pulsar = Pulsar.createServer server: createServer port

  ops = pulsar.channel 'notify:operators'

else
  pulsar =
    channel: ->
      on: ->
      emit: ->

module.exports = pulsar
