require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.joinChat @channelName, (err) =>
          false.should.eql err?

          # Try to leave
          @client.leaveChat @channelName, (err, channelName) =>
            false.should.eql err?
            channelName.should.eql @channelName

            # Check whether we're still in channel
            @client.getMyChats (err, chats) =>
              false.should.eql err?
              chats.length.should.eql 0
              done()