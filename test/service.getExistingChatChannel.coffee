require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Existing Chat Channel', ->

  it 'should not say to reconnect you if you have no session', (done) ->
    @client.getExistingChatChannel (err, data) ->
      false.should.eql err?
      false.should.eql data?
      done()

  it 'should say to reconnect you if you already have a session', (done) ->
    client = @getClient()
    client.ready =>
      data = {username: 'clientTest1'}
      client.newChat data, (err, {channel}) =>
        client.disconnect()
        client2 = @getClient()
        client2.ready ->
          client2.getExistingChatChannel (err, existingChannel) ->
            false.should.eql err?
            existingChannel.channel.should.eql channel
            client2.disconnect()
            done()
