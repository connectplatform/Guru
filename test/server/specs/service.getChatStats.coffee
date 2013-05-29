async = require 'async'
should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Get Chat Stats', ->

  it 'should return chat statistics', (done) ->

    @getAuthed =>

      @createChats (err, chats) =>
        targetChat = chats[0].id

        ChatSession.create {@sessionId, chatId: targetChat, relation: 'Invite'}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession

          @client.getChatStats {}, (err, stats) =>
            should.not.exist err
            should.exist stats

            {invites, invites: [{chatId, relation}]} = stats
            invites.length.should.equal 1
            chatId.should.equal targetChat
            relation.should.equal 'Invite'
            
            done()

  describe 'with various chats', ->
    beforeEach ->
      @generate = (done) =>
        #Create chats with proper context

        chats = [
            username: 'should show'
            websiteUrl: 'foo.com'
            specialtyName: 'Sales'
          ,
            username: 'should not show'
            websiteUrl: 'baz.com'
          ,
            username: 'should not show'
            websiteUrl: 'foo.com'
            specialtyName: 'Billing'
        ]
        async.forEach chats, @newChatWith.bind(@), done

    it 'should only return relevant chats', (done) ->
      @guru3Login (err, @client) =>
        @generate =>
          @client.getChatStats {}, (err, stats) =>
            should.not.exist err
            should.exist stats

            stats.unanswered.length.should.eql 1, 'expected 1 unanswered chat'
            done()

    it 'should return all chats for owner', (done) ->
      @ownerLogin (err, @client) =>
        @generate =>
          @client.getChatStats {}, (err, stats) =>
            should.not.exist err
            should.exist stats

            stats.unanswered.length.should.eql 3, 'expected 3 unanswered chats'
            done()

    it 'should display unanswered chats when I log in', (done) ->
      @guru3Login (err, @client) =>
        @generate =>
          @client.getChatStats {}, (err, stats) =>
            should.not.exist err
            should.exist stats

            stats.unanswered.length.should.eql 1, 'expected 1 unanswered chat'
            done()
