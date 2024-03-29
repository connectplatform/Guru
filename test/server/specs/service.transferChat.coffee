should = require 'should'
stoic = require 'stoic'

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
              {ChatSession} = stoic.models
              ChatSession(accountId).getByChat @chatId, (err, chatSessions) =>
                should.not.exist err

                # Get the chat session we care about
                chatSession = {}
                for cs in chatSessions when cs.sessionId is @targetSession
                  chatSession = cs

                chatSession.relationMeta.get 'type', (err, type) =>
                  type.should.eql 'transfer'
                  chatSession.relationMeta.get 'requestor', (err, requestor) =>
                    requestor.should.eql @sessionId
                    done()
