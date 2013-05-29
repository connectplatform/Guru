should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Transfer Chat', ->
  it "should let you transfer a chat to another operator", (done) ->
    # Setup
    @loginOperator (err, client) =>
      @getAuthed (_..., {accountId}) =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err

            # Try to transfer
            @client.transferChat {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
              should.not.exist err

              # Check whether transfer worked
              # TODO: use getMyChats to test this instead
              ChatSession.findOne {@chatId, sessionId: @targetSession}, (err, chatSession) =>
                should.not.exist err
                should.exist chatSession
                chatSession.relation.should.equal 'Transfer'
                chatSession.initiator.should.equal @sessionId
                done()
