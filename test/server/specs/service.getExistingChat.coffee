should = require 'should'

boiler 'Service - Get Existing Chat', ->
  beforeEach (done) ->
    @getAuthed -> done()

  it 'should not say to reconnect you if you have no ChatSession', (done) ->
    @client.getExistingChat {}, (err, {chatId}) ->
      should.not.exist err, 'expected no error from getExistingChat'
      should.not.exist chatId, 'expected no existingChat'
      done()

  it 'should say to reconnect you if you already have a ChatSession', (done) ->
    @newChatWith {username: 'clientTest1', websiteUrl: 'foo.com'}, (err, data) =>
      should.not.exist err, 'expected no error from newChat'
      should.exist @chatId, 'expected chatId'
      oldChatId = @chatId
      should.exist data
      should.exist data.sessionSecret

      {sessionSecret} = data
      @getClient (client2) =>
        client2.getExistingChat {sessionSecret}, (err, {chatId, reason}) ->
          should.not.exist err
          should.not.exist reason
          should.exist chatId, 'expected to find an existing chat'
          oldChatId.should.eql chatId
          done()
