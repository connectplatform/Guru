should = require 'should'

boiler 'Service - Get Existing Chat', ->
  beforeEach (done) ->
    @getAuthed -> done()

  it 'should not say to reconnect you if you have no session', (done) ->
    client = @getClient()
    client.ready ->
      client.getExistingChat {}, (err, {chatId}) ->
        should.not.exist err, 'expected no error from getExistingChat'
        should.not.exist chatId, 'expected no existingChat'
        client.disconnect()
        done()

  it 'should say to reconnect you if you already have a session', (done) ->
    @newChatWith {username: 'clientTest1', websiteUrl: 'foo.com'}, (err) =>
      should.not.exist err, 'expected no error from newChat'
      should.exist @chatId, 'expected chatId'
      oldChatId = @chatId

      @getClient (client2) =>
        client2.getExistingChat {sessionId: @visitorSession}, (err, {chatId, reason}) ->
          should.not.exist err
          should.not.exist reason
          should.exist chatId, 'expected to find an existing chat'
          oldChatId.should.eql chatId
          client2.disconnect()
          done()
