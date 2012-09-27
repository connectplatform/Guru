should = require 'should'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.acceptChat @chatId, (err) =>
          should.not.exist err

          # Try to leave
          @client.leaveChat @chatId, (err, channelName) =>
            should.not.exist err
            channelName.should.eql @chatId

            # Check whether we're still in channel
            @client.getMyChats (err, chats) =>
              should.not.exist err
              chats.length.should.eql 0

              # Check whether the chat has the right status
              @client.getActiveChats (err, [chat]) =>
                chat.status.should.eql 'waiting'

                done()

  it 'should not change status if there is another operator', (done) ->
    # Setup
    @newChat =>
      firstClient = @getClient()
      firstClient.ready =>
        firstClient.login @guru1Login, =>
          firstClient.acceptChat @chatId, (err) =>
            should.not.exist err
            firstClient.disconnect()

            @getAuthed =>
              @client.joinChat @chatId, (err) =>
                should.not.exist err

                # Try to leave
                @client.leaveChat @chatId, (err, channelName) =>
                  should.not.exist err
                  channelName.should.eql @chatId

                  # Check whether we're still in channel
                  @client.getMyChats (err, chats) =>
                    should.not.exist err
                    chats.length.should.eql 0

                    # Check whether the chat has the right status
                    @client.getActiveChats (err, [chat]) =>
                      chat.status.should.eql 'active'

                      done()
