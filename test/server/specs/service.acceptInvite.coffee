should = require 'should'

boiler 'Service - Accept Invite', ->
  it "should let an operator accept an invite", (done) ->
    # Setup
    @loginOperator (err, client) =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err
            @client.inviteOperator {@chatId, @targetSessionId}, (err) =>
              should.not.exist err

              client.acceptInvite {chatId: @chatId}, (err) =>
                should.not.exist err

                client.getMyChats {}, (err, {chats}) =>
                  should.not.exist err
                  should.exist chats
                  chats.length.should.eql 1
                  [chat] = chats
                  chat._id.should.eql @chatId
                  done()
