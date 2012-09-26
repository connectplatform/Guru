should = require 'should'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
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
                should.exist chat, 'expected one chat record'
                chat.status.should.eql 'waiting'

                done()

  it 'should not change status if there is another operator', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @guru1Login (err, firstClient) =>
          firstClient.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            firstClient.disconnect()

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
                    should.exist chat, 'expected one chat record'
                    chat.status.should.eql 'active'

                    done()
