should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Nonpresent Operators', ->
  it 'should return a list of operators not currently visible in chat', (done) ->
    # Setup
    @getAuthed (_..., {accountId}) =>
      @newChat =>
        @client.watchChat {chatId: @chatId}, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators {chatId: @chatId}, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 1
            operatorSessions[0].chatName.should.eql 'Owner Man'
            operatorSessions[0].role.should.eql 'Owner'

            # Make sure we have the right id
            {Session} = stoic.models
            Session(accountId).get(operatorSessions[0].id).chatName.get (err, chatName) =>
              chatName.should.eql 'Owner Man'
              done()

  it 'should not return operators who are visible in the chat', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @client.acceptChat {chatId: @chatId}, (err) =>
          should.not.exist err

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators {chatId: @chatId}, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 0
            done()
