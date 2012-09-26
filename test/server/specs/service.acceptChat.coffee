should = require 'should'

boiler 'Service - Accept Chat', ->

  it 'should join the operator into the chat', (done) ->
    @newChat =>
      @getAuthed =>
        @client.acceptChat @chatChannelName, (err, result) =>
          false.should.eql err?
          result.status.should.eql "OK"
          result.chatId.should.eql @chatChannelName

          #Try to post in channel
          outgoing =
            session: @client.cookie 'session'
            message: 'accept chat worked'

          client = @getPulsar()
          chan = client.channel @chatChannelName

          chan.on 'serverMessage', (data) ->
            data.message.should.eql outgoing.message
            done()

          # send test data
          chan.emit 'clientMessage', outgoing

  it 'should only let one operator join the chat', (done) ->
    @newChat =>

        @guru1Login (err, client) =>
          client.acceptChat @chatChannelName, (err, result) =>
            false.should.eql err?
            result.status.should.eql "OK"
            client.disconnect()

            @getAuthed =>
              @client.acceptChat @chatChannelName, (err, result) =>
                false.should.eql err?
                result.status.should.eql "ALREADY ACCEPTED"
                done()
