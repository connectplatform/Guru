should = require 'should'

boiler 'Service - Get Existing Chat', ->
  beforeEach (done) ->
    @getAuthed -> done()

  it 'should not say to reconnect you if you have no session', (done) ->
    client = @getClient()
    client.ready ->
      client.getExistingChat {}, (err, data) ->
        should.not.exist err
        should.not.exist data
        client.disconnect()
        done()

  it 'should say to reconnect you if you already have a session', (done) ->
    client = @getClient()
    client.ready =>
      data = {username: 'clientTest1', websiteUrl: 'foo.com'}
      client.newChat data, (err, {chatId}) =>
        should.not.exist err
        session = client.cookie 'session'
        client.disconnect()

        client2 = @getClient()
        client2.ready ->
          client2.cookie 'session', session
          client2.getExistingChat (err, data) ->
            should.not.exist err
            oldChatId = data.chatId
            should.exist oldChatId, 'expected to find an existing chat'
            oldChatId.should.eql chatId
            client2.disconnect()
            done()
