should = require 'should'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.acceptChat @chatChannelName, (err) =>
          should.not.exist err

          # Try to leave
          @client.leaveChat @chatChannelName, (err, channelName) =>
            should.not.exist err
            channelName.should.eql @chatChannelName

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
          firstClient.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            firstClient.disconnect()

            @getAuthed =>
              @client.joinChat @chatChannelName, (err) =>
                should.not.exist err

                # Try to leave
                @client.leaveChat @chatChannelName, (err, channelName) =>
                  should.not.exist err
                  channelName.should.eql @chatChannelName

                  # Check whether we're still in channel
                  @client.getMyChats (err, chats) =>
                    should.not.exist err
                    chats.length.should.eql 0

                    # Check whether the chat has the right status
                    @client.getActiveChats (err, [chat]) =>
                      chat.status.should.eql 'active'

                      done()
