should = require 'should'
stoic = require 'stoic'

boiler 'Service - Accept Invite', ->
  it "should let an operator accept an invite", (done) ->
    acceptInvite = config.require 'services/acceptInvite'
    getMyChats = config.require 'services/getMyChats'

    # Setup
    @loginOperator =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err
            @client.inviteOperator {chatId: @chatId, targetSession: @targetSession}, (err) =>
              should.not.exist err

              acceptInvite {chatId: @chatId, sessionId: @targetSession}, (err, chatId) =>

                getMyChats {sessionId: @targetSession}, (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatId
                  done()
