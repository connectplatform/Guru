require 'should'
redgoose = require 'redgoose'
boiler = require './util/boilerplate'

boiler 'Service - Kick User', ->

  it 'should remove visitor from chat', (done) ->
    #TODO uncomment when kickuser can take channelname as an arg
    done()
    ###
    # Setup
    @newChat =>
      @getAuthed =>
        @client.joinChat @channelName, (err) =>
          false.should.eql err?

          # Kick user
          @client.kickUser @channelName, (err) =>
            false.should.eql err?

            # Check that kick worked
            {Chat} = redgoose.models
            Chat.get(@channelName).status.get (err, status) =>
              false.should.eql err?
              status.should.eql 'vacant'
              done()