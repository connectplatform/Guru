should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Accept Chat', (globals) ->

  it 'should exist', (done) ->
    veinClient = globals.getClient()
    veinClient.ready (services) ->
      services.should.include 'acceptChat'
      done()
