require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Active Chats', (globals) ->

  it 'should exist', (done) ->
    client = globals.getClient()
    client.ready (services) ->
      services.should.include 'getActiveChats'
      client.disconnect()
      done()

###TODO: this needs login setup

  it 'should return data on all existing chats', (done)->
    client = globals.getClient()
    client.ready ->
      data = {username: 'foo'}
      client.newChat data, (err, data)->
        client.getActiveChats (err, data)->
          console.log "got data: #{data}"
          client.disconnect()
          done()