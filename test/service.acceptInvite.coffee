should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

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

boiler 'Service - Accept Invite', ->
  it "should let an operator accept an invite", (done) ->
    acceptInvite = require '../server/domain/_services/acceptInvite'
    getMyChats = require '../server/domain/_services/getMyChats'
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @channelName, (err) =>
            should.not.exist err
            @client.inviteOperator @targetSession, @channelName, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                send: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @channelName

                  getMyChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    send: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @channelName
                      done()

                  getMyChats getMyChatsRes

              acceptInvite mockRes, @channelName
