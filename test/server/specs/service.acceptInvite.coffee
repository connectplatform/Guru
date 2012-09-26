should = require 'should'
stoic = require 'stoic'

boiler 'Service - Accept Invite', ->

  beforeEach (done) ->
    @loginOperator = (cb) =>

      client = @getClient()
      client.ready =>
        client.login @guru1Login, (err) =>
          throw new Error err if err
          @targetSession = client.cookie 'session'
          client.disconnect()
          cb()
    done()

  it "should let an operator accept an invite", (done) ->
    acceptInvite = config.require 'services/acceptInvite'
    getMyChats = config.require 'services/getMyChats'

    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.inviteOperator @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              mockRes =
                cookie: (string) => @targetSession
                reply: (err, chatId) =>
                  #body of test here
                  should.not.exist err
                  chatId.should.eql @chatChannelName

                  getMyChatsRes =
                    cookie: (string) =>
                      @targetSession if string is 'session'
                    reply: (err, chats) =>
                      should.not.exist err
                      chats.length.should.eql 1
                      chats[0].id.should.eql @chatChannelName
                      done()

                  getMyChats getMyChatsRes

              acceptInvite mockRes, @chatChannelName
