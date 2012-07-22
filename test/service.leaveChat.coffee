should = require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.joinChat @channelName, (err) =>
          should.not.exist err

          # Try to leave
          @client.leaveChat @channelName, (err, channelName) =>
            should.not.exist err
            channelName.should.eql @channelName

            # Check whether we're still in channel
            @client.getMyChats (err, chats) =>
              should.not.exist err
              chats.length.should.eql 0

              # Check whether the chat has the right status
              @client.getActiveChats (err, [chat]) =>
                chat.status.should.eql 'waiting'

                done()