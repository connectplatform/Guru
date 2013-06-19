should = require 'should'
{ChatSession} = config.require('load/mongo').models

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    @guru1Login (err, guru1, vars) =>
      should.exist guru1

      @newChat =>
        ChatSession.find {@chatId}, (err, chatSessions) =>
          guru1.acceptChat {@chatId}, (err) =>
            should.not.exist err
            # done()

            # Try to leave
            guru1.leaveChat {@chatId}, (err) =>
              should.not.exist err

              # Check whether we're still in channel
              guru1.getMyChats {}, (err, {chats}) =>
                should.not.exist.err
                chats.should.be.empty

                # Check whether the chat has the right status
                guru1.getActiveChats {}, (err, {chats}) =>
                  should.not.exist err
                  should.exist chats
                  chats.should.not.be.empty
                  [chat] = chats
                  should.exist chat
                  chat.status.should.equal 'Waiting'
                  done()

  it 'should not change status if there is another operator', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @guru1Login (err, firstClient) =>
          firstClient.acceptChat {@chatId}, (err) =>
            should.not.exist err

            @client.joinChat {@chatId}, (err) =>
              should.not.exist err

              # Try to leave
              @client.leaveChat {@chatId}, (err) =>
                should.not.exist err

                # Check whether we're still in channel
                @client.getMyChats {}, (err, {chats}) =>
                  should.not.exist err
                  chats.should.be.empty

                # Check whether the chat has the right status
                @client.getActiveChats {}, (err, {chats}) =>
                  should.not.exist err
                  chats.should.not.be.empty
                  [chat] = chats
                  should.exist chat, 'expected one chat record'
                  chat.status.should.eql 'Active'

                  done()
