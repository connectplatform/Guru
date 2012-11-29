Pulsar = require "pulsar"
createServer = require './createServer'

port = process.env.GURU_PULSAR_PORT or config.app.pulsarPort

unless port is 'DISABLED'
  server = createServer port
  pulsar = Pulsar.createServer server

  ops = pulsar.channel 'notify:operators'

else
  pulsar =
    channel: ->
      on: ->
      emit: ->

module.exports = pulsar
