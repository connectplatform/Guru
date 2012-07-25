should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

getActiveChats = require '../server/domain/_services/getActiveChats'

beforeEach (done) ->
  @loginOperator = (cb) =>
    loginData =
      email: 'guru1@torchlightsoftware.com'
      password: 'foobar'
    client = @getClient()
    client.ready =>
      client.login loginData, (err) =>
        throw new Error err if err
        @targetSession = client.cookie 'session'
        client.disconnect()
        cb()
  done()

boiler 'Service - Get Active Chats', ->
  it "should display a chat status based on whether an operator is invited", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @channelName, (err) =>
            should.not.exist err
            @client.inviteOperator @targetSession, @channelName, (err) =>
              should.not.exist err

              # Do test
              getActiveChatsRes =
                cookie: (string) => @targetSession
                send: (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @channelName
                  chats[0].status.should.eql 'invite'
                  done()

              getActiveChats getActiveChatsRes
