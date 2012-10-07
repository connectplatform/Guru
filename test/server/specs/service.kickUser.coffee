should = require 'should'
stoic = require 'stoic'

boiler 'Service - Kick User', ->

  it 'should remove visitor from chat', (done) ->
    # Setup
    @getAuthed =>
      @newChat =>
        @client.joinChat @chatId, (err) =>
          should.not.exist err

          # Kick user
          @client.kickUser @chatId, (err) =>
            should.not.exist err

            # Check that kick worked
            {Chat} = stoic.models
            Chat.get(@chatId).status.get (err, status) =>
              should.not.exist err
              status.should.eql 'vacant'
              done()
