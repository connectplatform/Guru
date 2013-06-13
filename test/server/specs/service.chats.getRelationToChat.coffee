should = require 'should'

# getRelationToChat = config.service['chats/getRelationToChat']

boiler 'Service - Get Relation to Chat', ->
  it 'it should get my relation to the Chat when I am a member', (done) ->
    @guru1Login (err, @guru1, {sessionSecret}) =>
      should.exist sessionSecret
      @newChat (err, {chatId}) =>
        @guru1.joinChat {chatId}, (err) =>
          should.not.exist err
          config.services['chats/getRelationToChat'] {sessionSecret, chatId}, (err, {relation}) =>
            should.not.exist err
            should.exist relation
            relation.should.equal 'Member'
            done()

  it 'it should get my relation to the Chat when I am watching', (done) ->
    @guru1Login (err, @guru1, {sessionSecret}) =>
      should.exist sessionSecret
      @newChat (err, {chatId}) =>
        @guru1.watchChat {chatId}, (err) =>
          should.not.exist err
          config.services['chats/getRelationToChat'] {sessionSecret, chatId}, (err, {relation}) =>
            should.not.exist err
            should.exist relation
            relation.should.equal 'Watching'
            done()

  it 'it should not tell me I have a relation to Chat when I do not', (done) ->
    @guru1Login (err, @guru1, {sessionSecret}) =>
      should.exist sessionSecret
      @newChat (err, {chatId}) =>
        config.services['chats/getRelationToChat'] {sessionSecret, chatId}, (err, {relation}) =>
          should.not.exist err
          should.not.exist relation
          done()
