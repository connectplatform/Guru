should = require 'should'

boiler 'Service - Get My Chats', ->

  it "should return data on all of a particular operator's chats", (done) ->
    @getAuthed =>

      # Given a chat to join
      @newChatWith {websiteUrl: 'foo.com', username: 'joinMe', arbitrary: 'someValue'}, (err, {data: {chatId}}) =>
        console.log 'chatId:', chatId

        # And a chat that we're not joining
        @newChatWith {websiteUrl: 'foo.com', username: 'butNotMe'}, =>

          # When we join the chat
          @client.joinChat {chatId: chatId}, (err, data) =>

            # Then the data should be correct
            @client.getMyChats (err, data) =>
              should.not.exist err
              data.length.should.eql 1
              [chatData] = data
              chatData.visitor.username.should.eql 'joinMe'
              should.exist chatData.visitor.referrerData.arbitrary, 'expected referrerData'
              chatData.visitor.referrerData.arbitrary.should.eql 'someValue'
              chatData.status.should.eql 'waiting'
              new Date chatData.creationDate #just need this to not cause an error
              done()

  it "orphan chatSession should not shit the bed", (done) ->
    {ChatSession} = require('stoic').models
    @getAuthed (err, @client, accountId) =>

      # Given an orphan ChatSession
      ChatSession(accountId).add @client.cookie('session'), 'chat_bar', {}, (err, chatSession) =>
        @client.getMyChats (err, data) =>
          should.not.exist err
          data.length.should.eql 0
          done()
