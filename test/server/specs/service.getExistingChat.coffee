should = require 'should'

boiler 'Service - Get Existing Chat', ->
  beforeEach (done) ->
    @getAuthed -> done()

  it 'should not say to reconnect you if you have no session', (done) ->
    client = @getClient()
    client.ready ->
      client.getExistingChat (err, data) ->
        false.should.eql err?
        false.should.eql data?
        client.disconnect()
        done()

  it 'should say to reconnect you if you already have a session', (done) ->
    client = @getClient()
    client.ready =>
      data = {username: 'clientTest1', websiteUrl: 'foo.com'}
      client.newChat data, (err, data) =>
        should.not.exist err
        {chatId} = data
        session = client.cookie 'session'
        client.disconnect()

        client2 = @getClient()
        client2.ready ->
          client2.cookie 'session', session
          client2.getExistingChat (err, existingChannel) ->
            should.not.exist err
            should.exist existingChannel, 'expected to find an existing channel'
            existingChannel.chatId.should.eql chatId
            client2.disconnect()
            done()
