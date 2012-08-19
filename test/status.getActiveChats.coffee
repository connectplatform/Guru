should = require 'should'
boiler = require './util/boilerplate'
stoic = require 'stoic'

getActiveChats = require '../server/domain/_services/getActiveChats'

beforeEach (done) ->
  @loginOperator = (cb) =>
    loginData =
      email: 'guru1@foo.com'
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
  it "should have a chat relation based on whether an operator is invited", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.inviteOperator @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              getActiveChatsRes =
                cookie: (string) => @targetSession
                reply: (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatChannelName
                  chats[0].relation.should.eql 'invite'
                  done()

              getActiveChats getActiveChatsRes
