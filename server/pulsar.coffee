config = require './config'
http = require 'http'
Pulsar = require "pulsar"

port = process.env.GURU_PULSAR_PORT or config.app.pulsarPort

unless port is 'DISABLED'
  server = http.createServer().listen port
  pulsar = Pulsar.createServer server: server

  ops = pulsar.channel 'notify:operators'

module.exports = pulsar
