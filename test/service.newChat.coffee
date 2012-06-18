should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', (globals) ->

  it 'should exist', (done) ->
    veinClient = globals.getClient()
    veinClient.ready (services) ->
      services.should.include 'newChat'
      done()
