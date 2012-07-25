
should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

acceptTransfer = require '../server/domain/_services/acceptTransfer'
getMyChats = require '../server/domain/_services/getMyChats'

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

boiler 'Service - Accept Transfer', ->
  it "should let an operator accept a transfer and kick the requesting operator", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @channelName, (err) =>
            should.not.exist err
            @client.transferChat @targetSession, @channelName, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                send: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @channelName

                  # after the tranfer, target operator should be in the chat
                  getAcceptorsChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    send: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @channelName

                      # after the transfer, transferring operator should not be in the chat
                      @client.getMyChats (err, chats) =>
                        should.not.exist err
                        chats.length.should.eql 0
                        done()

                  getMyChats getAcceptorsChatsRes

              acceptTransfer mockRes, @channelName
