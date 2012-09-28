should = require 'should'
stoic = require 'stoic'

boiler 'Service - Accept Invite', ->
  it "should let an operator accept an invite", (done) ->
    acceptInvite = config.require 'services/acceptInvite'
    getMyChats = config.require 'services/getMyChats'

    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatId, (err) =>
            should.not.exist err
            @client.inviteOperator @chatId, @targetSession, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                reply: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @chatId

                  getMyChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    reply: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @chatId
                      done()

                  getMyChats getMyChatsRes

              acceptInvite mockRes, @chatId
