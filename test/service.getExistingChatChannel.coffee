require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', (globals) ->

  it 'should exist', (done) ->
    veinClient = globals.getClient()
    veinClient.ready (services) ->
      services.should.include 'getExistingChatChannel'
      veinClient.disconnect()
      done()

  it 'should not say to reconnect you if you have no session', (done)->
    client = globals.getClient()
    client.ready (services) ->
      client.getExistingChatChannel (err, data)->
        false.should.eql err?
        false.should.eql data?
        client.disconnect()
        done()

  it 'should say to reconnect you if you already have a session', (done)->
    client = globals.getClient()
    client.ready ->
      data = {username: 'clientTest1'}
      client.newChat data, (err, data)->
        channelName = data.channel
        client.disconnect()
        client2 = globals.getClient()
        client2.ready ->
          client2.getExistingChatChannel (err, data)->
            false.should.eql err?
            data.channel.should.eql channelName
            client2.disconnect()
            done()