async = require 'async'
should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Chat Stats', ->

  it 'should return chat statistics', (done) ->
    {ChatSession} = stoic.models

    @getAuthed =>
      session = @client.cookie 'session'

      @createChats (err, chats) =>
        targetChat = chats[0].id

        ChatSession.add session, targetChat, {type: 'invite'}, =>
          @client.getChatStats (err, stats) =>
            should.not.exist err

            {invites, invites: [{chatId, type}]} = stats # destructure me, baby
            invites.length.should.eql 1
            chatId.should.eql targetChat
            type.should.eql 'invite'
            done()

  describe 'with various chats', ->
    beforeEach ->

      @generate = (done) ->
        chats = [
            username: 'should show'
            params: {websiteUrl: 'foo.com'}
            department: 'Sales'
          ,
            username: 'should not show'
            params: {websiteUrl: 'baz.com'}
          ,
            username: 'should not show'
            params: {websiteUrl: 'foo.com'}
            department: 'Billing'
        ]
        async.forEach chats, @newChatWith, done

    it 'should only return relevant chats', (done) ->
      @guru3Login (err, @client) =>
        @generate =>
          @client.getChatStats (err, stats) =>
            should.not.exist err
            should.exist stats

            stats.unanswered.length.should.eql 1, 'expected 1 chat'
            done()

    it 'should return all chats for admin', (done) ->
      @adminLogin (err, @client) =>
        @generate =>
          @client.getChatStats (err, stats) =>
            should.not.exist err
            should.exist stats

            stats.unanswered.length.should.eql 3, 'expected 3 chats'
            done()

    #it 'should display unanswered chats when I log in', (done) ->
