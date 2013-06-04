should = require 'should'
db = config.require 'load/mongo'
{Account, Chat, ChatSession, Session, User, Website} = db.models

boiler 'Service - Logout', ->

  it 'should remove your session', (done) ->
    @ownerLogin (err, client, {sessionSecret, accountId}) =>
      should.not.exist err
      sessionId = client.localStorage.sessionId
      client.logout (err) =>
        Session.findById sessionId, (err, session) ->
          should.not.exist err
          should.not.exist session
          done()

  it 'should remove dependent ChatSessions', (done) ->
    @ownerLogin (err, client, {sessionSecret, accountId}) =>
      should.not.exist err
      @sessionId = client.localStorage.sessionId
      Account.findOne {}, (err, account) =>
        @accountId = account._id
        User.findOne {accountId: @accountId}, (err, user) =>
          should.not.exist err
          @userId = user._id
          Website.findOne {accountId: @accountId}, (err, website) =>
            should.not.exist err
            should.exist website
            @websiteId = website._id
            @websiteUrl = website.url
            chatData =
              accountId: @accountId
              websiteId: @websiteId
              websiteUrl: @websiteUrl
              name: 'Visitor'
            Factory.create 'chat', chatData, (err, chat) =>
              should.not.exist err
              @chatId = chat._id
              Factory.create 'chatSession', {@sessionId, @chatId}, (err, chatSession) =>
                should.not.exist err
                should.exist chatSession
                client.logout (err) =>
                  should.not.exist err
                  ChatSession.find {@sessionId}, (err, chatSessions) =>
                    should.not.exist err
                    should.exist chatSessions
                    chatSessions.should.be.empty
                    done err
