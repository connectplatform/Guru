should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Nonpresent Opertors', ->
  it "should return a list of operators not currently visible in chat", (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @client.watchChat @chatId, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators @chatId, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 1
            operatorSessions[0].chatName.should.eql "Admin Guy"
            operatorSessions[0].role.should.eql "Administrator"

            # Make sure we have the right id
            {Session} = stoic.models
            Session.get(operatorSessions[0].id).chatName.get (err, chatName) =>
              chatName.should.eql "Admin Guy"
              done()

  it "should not return operators who are visible in the chat", (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @client.acceptChat @chatId, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators @chatId, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 0
            done()
