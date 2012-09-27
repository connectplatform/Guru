should = require 'should'

boiler 'Service - Get Existing Chat Channel', ->

  it 'should not say to reconnect you if you have no session', (done) ->
    client = @getClient()
    client.ready ->
      client.getExistingChatChannel (err, data) ->
        false.should.eql err?
        false.should.eql data?
        client.disconnect()
        done()

  it 'should say to reconnect you if you already have a session', (done) ->
    client = @getClient()
    client.ready =>
      data = {username: 'clientTest1'}
      client.newChat data, (err, {chatId}) =>
        session = client.cookie 'session'
        client.disconnect()

        client2 = @getClient()
        client2.ready ->
          client2.cookie 'session', session
          client2.getExistingChatChannel (err, existingChannel) ->
            should.not.exist err
            should.exist existingChannel, 'expected to find an existing channel'
            existingChannel.channel.should.eql chatId
            client2.disconnect()
            done()
