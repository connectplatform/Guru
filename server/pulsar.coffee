config = require './config'
http = require 'http'
Pulsar = require "pulsar"

pulsar = new Pulsar http.createServer().listen(process.env.GURU_PULSAR_PORT or config.app.pulsarPort)
pulsar.channel 'notify:operators'

module.exports = pulsar