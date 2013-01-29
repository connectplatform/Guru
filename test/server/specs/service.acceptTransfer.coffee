should = require 'should'

boiler 'Service - Accept Transfer', ->
  it "should let an operator accept a transfer and kick the requesting operator", (done) ->
    acceptTransfer = config.require 'services/acceptTransfer'
    getMyChats = config.require 'services/getMyChats'

    # Setup
    @loginOperator (err, transferee) =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err

            @client.transferChat {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
              should.not.exist err

              # Do test
              transferee.acceptTransfer {chatId: @chatId}, (err, {chatId}) =>
                should.not.exist err
                chatId.should.eql @chatId

                # after the tranfer, target operator should be in the chat
                transferee.getMyChats {sessionId: @targetSession}, (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatId

                  # after the transfer, transferring operator should not be in the chat
                  @client.getMyChats {}, (err, chats) =>
                    should.not.exist err
                    chats.length.should.eql 0
                    done()
