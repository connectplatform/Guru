should = require 'should'

boiler 'Service - Leave Chat', ->

  it 'should remove current operator from chat', (done) ->
    @guru1Login (err, guru1, vars) =>
      should.exist guru1
      console.log 'guru1 vars:', {vars}
      @newChat =>
        db = config.require 'load/mongo'
        {ChatSession} = db.models
        ChatSession.find {@chatId}, (err, chatSessions) =>
          console.log {chatSessions}
          # done()
          console.log 'localStorage', guru1.localStorage
          guru1.acceptChat {@chatId}, (err) =>
            should.not.exist err
            done()

        #   # Try to leave
        #   guru1.leaveChat {@chatId}, (err) =>
        #     should.not.exist err

        #     # Check whether we're still in channel
        #     guru1.getMyChats {}, (err, {chats}) =>
        #       should.not.exist.err
        #       chats.should.be.empty

        #       # Check whether the chat has the right status
        #       guru1.getActiveChats {}, (err, {chats}) =>
        #         should.not.exist err
        #         should.exist chats
        #         chats.should.not.be.empty
        #         [chat] = chats
        #         should.exist chat
        #         chat.status.should.equal 'Waiting'
        #         done()
    
    # # Setup
    # @getAuthed =>
    #   console.log '@client.localStorage', @client.localStorage
    #   @newChat =>
    #     console.log '@client.localStorage', @client.localStorage
    #     console.log {@chatId}
    #     @client.acceptChat {@chatId}, (err) =>
    #       console.log 'DEBUG', 1
    #       should.not.exist err

    #       # Try to leave
    #       @client.leaveChat {chatId: @chatId}, (err) =>
    #         should.not.exist err

    #         # Check whether we're still in channel
    #         @client.getMyChats {}, (err, {chats}) =>
    #           should.not.exist err
    #           chats.length.should.eql 0

    #           # Check whether the chat has the right status
    #           @client.getActiveChats {}, (err, {chats}) =>
    #             should.not.exist err
    #             [chat] = chats
    #             should.exist chat, 'expected one chat record'
    #             chat.status.should.eql 'Waiting'
    #             done()

  it 'should not change status if there is another operator', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @guru1Login (err, firstClient) =>
          firstClient.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err

            @client.joinChat {chatId: @chatId}, (err) =>
              should.not.exist err

              # Try to leave
              @client.leaveChat {chatId: @chatId}, (err) =>
                should.not.exist err

                # Check whether we're still in channel
                @client.getMyChats {}, (err, {chats}) =>
                  should.not.exist err
                  chats.length.should.eql 0

                # Check whether the chat has the right status
                @client.getActiveChats {}, (err, {chats}) =>
                  should.not.exist err
                  [chat] = chats
                  should.exist chat, 'expected one chat record'
                  chat.status.should.eql 'Active'

                  done()
