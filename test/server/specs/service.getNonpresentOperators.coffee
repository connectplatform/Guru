should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Nonpresent Opertors', ->
  it "should return a list of operators not currently visible in chat", (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.watchChat @chatChannelName, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators @chatChannelName, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 1
            operatorSessions[0].chatName.should.eql "Admin"
            operatorSessions[0].role.should.eql "Administrator"

            # Make sure we have the right id
            {Session} = stoic.models
            Session.get(operatorSessions[0].id).chatName.get (err, chatName) =>
              chatName.should.eql "Admin"
              done()

  it "should not return operators who are visible in the chat", (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.acceptChat @chatChannelName, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators @chatChannelName, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 0
            done()
