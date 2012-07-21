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
          @client.getNonpresentOperators @channelName, (err, operatorIds) =>
            should.not.exist err
            operatorIds.length.should.eql 1
            {Session} = redgoose.models
            Session.get(operatorIds[0]).chatName.get (err, chatname) =>
              should.not.exist err
              chatname.should.eql "God"
              done()
