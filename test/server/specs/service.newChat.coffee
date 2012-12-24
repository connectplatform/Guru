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

          # Then I should see my message
          data.message.should.eql 'hello!'
          done()

        # When I send a message
        visitor.say {message: 'hello!', chatId: @chatId}, (err) =>
          should.not.exist err
          visitor.disconnect()

  it 'should notify operators of a new chat', (done) ->
    @getAuthed =>
      session = @client.cookie 'session'
      should.exist session
      notify = @getPulsar().channel "notify:session:#{session}"
      notify.on 'unansweredChats', ({count}) =>
        count.should.eql 1
        notify.removeAllListeners 'unansweredChats'
        done()

      @newChat ->

  it 'should return {noOperators: true} if no operators are available', (done) ->
    @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
      @newChatWith {username: 'visitor', websiteUrl: 'bar.com'}, (err, {data}) ->
        should.not.exist err
        should.exist data
        data.should.eql {noOperators: true}
        done()

  it 'should create a chatsession', (done) ->
    {ChatSession} = require('stoic').models
    @getAuthed =>
      @newChat =>
        ChatSession(@account._id).getByChat @chatId, (err, chatSession) ->
          should.not.exist err
          should.exist chatSession
          done()
