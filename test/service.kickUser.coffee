should = require 'should'
redgoose = require 'redgoose'
boiler = require './util/boilerplate'

boiler 'Service - Kick User', ->

  it 'should remove visitor from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.joinChat @channelName, (err) =>
          should.not.exist err

          # Kick user
          @client.kickUser @channelName, (err) =>
            should.not.exist err

            # Check that kick worked
            {Chat} = redgoose.models
            Chat.get(@channelName).status.get (err, status) =>
              should.not.exist err
              status.should.eql 'vacant'
              done()