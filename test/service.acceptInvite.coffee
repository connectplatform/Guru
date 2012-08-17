should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Accept Invite', ->

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

  it "should let an operator accept an invite", (done) ->
    acceptInvite = require '../server/domain/_services/acceptInvite'
    getMyChats = require '../server/domain/_services/getMyChats'
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.inviteOperator @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                reply: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @chatChannelName

                  getMyChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    reply: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @chatChannelName
                      done()

                  getMyChats getMyChatsRes

              acceptInvite mockRes, @chatChannelName
