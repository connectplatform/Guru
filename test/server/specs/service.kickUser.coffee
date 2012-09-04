should = require 'should'
stoic = require 'stoic'

boiler 'Service - Kick User', ->

  it 'should remove visitor from chat', (done) ->
    # Setup
    @newChat =>
      @getAuthed =>
        @client.joinChat @chatChannelName, (err) =>
          should.not.exist err

          # Kick user
          @client.kickUser @chatChannelName, (err) =>
            should.not.exist err

            # Check that kick worked
            {Chat} = stoic.models
            Chat.get(@chatChannelName).status.get (err, status) =>
              should.not.exist err
              status.should.eql 'vacant'
              done()
