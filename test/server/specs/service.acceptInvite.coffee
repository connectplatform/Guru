should = require 'should'

boiler 'Service - Accept Invite', ->
  it "should let an operator accept an invite", (done) ->
    # Setup
    @loginOperator (err, client) =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err
            @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
              should.not.exist err

              client.acceptInvite {chatId: @chatId}, (err) =>
                should.not.exist err

                client.getMyChats {}, (err, {chats}) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatId
                  done()
