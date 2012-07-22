should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Get Nonpresent Opertors', ->
  it "should return a list of operators not currently visible in chat", (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.watchChat @channelName, (err) =>

          # Get a list of operators who are online and not visible in chat
          @client.getNonpresentOperators @channelName, (err, operatorSessions) =>
            should.not.exist err

            # Validate returned data
            operatorSessions.length.should.eql 1
            operatorSessions[0].chatName.should.eql "God"
            operatorSessions[0].role.should.eql "Administrator"

            # Make sure we have the right id
            {Session} = redgoose.models
            Session.get(operatorSessions[0].id).chatName.get (err, chatName) =>
              chatName.should.eql "God"
              done()
