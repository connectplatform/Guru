should = require 'should'
stoic = require 'stoic'

getActiveChats = config.require 'services/getActiveChats'

boiler 'Service - Get Active Chats', ->
  it "should have a chat relation based on whether an operator is invited", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.inviteOperator @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              getActiveChatsRes =
                cookie: (string) => @targetSession
                reply: (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatChannelName
                  chats[0].relation.should.eql 'invite'
                  done()

              getActiveChats getActiveChatsRes
