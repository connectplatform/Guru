should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Get My Chats', ->

  it "should return data on all of a particular operator's chats", (done) ->
    @getAuthed =>

      # Given a chat to join
      @newChatWith {websiteUrl: 'foo.com', username: 'joinMe', arbitrary: 'someValue'}, (err, {chatId}) =>

        # And a chat that we're not joining
        @newChatWith {websiteUrl: 'foo.com', username: 'butNotMe'}, =>

          # When we join the chat
          @client.joinChat {chatId: chatId}, (err, data) =>
            should.not.exist err
            should.exist data
            
            # Then the data should be correct
            @client.getMyChats (err, {chats}) =>
              should.not.exist err
              should.exist chats
              chats.length.should.equal 1
              [chat] = chats
              chat.name.should.equal 'joinMe'
              chat.websiteUrl.should.equal 'foo.com'
              chat.status.should.equal 'Waiting'
              done()

  it "orphan chatSession should not make things blow up", (done) ->
    @getAuthed (err, @client, {sessionId, accountId}) =>

      # Given an orphan ChatSession
      @newChatWith {websiteUrl: 'foo.com', username: 'someVisitor'}, (err, {chatId}) =>
        # The Operator should not be spuriously associated with the Chat
        @client.getMyChats (err, {chats}) =>
          should.not.exist err
          should.exist chats
          chats.should.be.empty
          done()
