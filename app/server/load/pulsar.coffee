Pulsar = require "pulsar"
createServer = require './createServer'

port = process.env.GURU_PULSAR_PORT or config.app.pulsarPort

unless port is 'DISABLED'
  pulsar = Pulsar.createServer server: createServer port

  ops = pulsar.channel 'notify:operators'

module.exports = pulsar
