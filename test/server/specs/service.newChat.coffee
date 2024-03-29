should = require 'should'

boiler 'Service - New Chat', ->

  it 'should let you chat', (done) ->
    # Given I am logged in
    @getAuthed =>

      # And I have a chat
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, visitor) =>

        # And I am listening on the channel
        @channel = @getPulsar().channel @chatId
        @channel.on 'serverMessage', (data) ->
          if data.username is 'visitor'

            # Then I should see my message
            data.message.should.eql 'hello!'
            done()

        # When I send a message
        visitor.say {message: 'hello!', chatId: @chatId}, (err) =>
          should.not.exist err

  it 'should notify operators of a new chat', (done) ->
    @getAuthed =>
      should.exist @sessionId
      notify = @getPulsar().channel "notify:session:#{@sessionId}"
      notify.once 'unansweredChats', ({count}) =>
        count.should.eql 1
        done()

      @newChat ->

  it 'should return {noOperators: true} if no operators are available', (done) ->
    @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
      @newChatWith {username: 'visitor', websiteUrl: 'bar.com'}, (err, {noOperators}) ->
        should.not.exist err
        should.exist noOperators
        noOperators.should.eql true
        done()

  it 'should create a chatsession', (done) ->
    {ChatSession} = require('stoic').models
    @getAuthed =>
      @newChat =>
        ChatSession(@account._id).getByChat @chatId, (err, chatSession) ->
          should.not.exist err
          should.exist chatSession
          done()
