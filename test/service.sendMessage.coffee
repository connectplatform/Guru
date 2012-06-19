should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Send Message', (globals) ->

  it 'should exist', (done) ->
    veinClient = globals.getClient()
    veinClient.ready (services) ->
      services.should.include 'sendMessage'
      veinClient.disconnect()
      done()
