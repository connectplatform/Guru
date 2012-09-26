should = require 'should'
stoic = require 'stoic'

boiler 'Service - Accept Transfer', ->
  it "should let an operator accept a transfer and kick the requesting operator", (done) ->
    acceptTransfer = config.require 'services/acceptTransfer'
    getMyChats = config.require 'services/getMyChats'

    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.transferChat @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                reply: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @chatChannelName

                  # after the tranfer, target operator should be in the chat
                  getAcceptorsChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    reply: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @chatChannelName

                      # after the transfer, transferring operator should not be in the chat
                      @client.getMyChats (err, chats) =>
                        should.not.exist err
                        chats.length.should.eql 0
                        done()

                  getMyChats getAcceptorsChatsRes

              acceptTransfer mockRes, @chatChannelName
