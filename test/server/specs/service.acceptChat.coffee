should = require 'should'

boiler 'Service - Accept Chat', ->

  it 'should join the operator into the chat', (done) ->
    @newChat =>
      @getAuthed =>
        @client.acceptChat @chatId, (err, result) =>
          false.should.eql err?
          result.status.should.eql "OK"
          result.chatId.should.eql @chatId

          #Try to post in channel
          outgoing =
            session: @client.cookie 'session'
            message: 'accept chat worked'

          client = @getPulsar()
          chan = client.channel @chatId

          chan.on 'serverMessage', (data) ->
            data.message.should.eql outgoing.message
            done()

          # send test data
          chan.emit 'clientMessage', outgoing

  it 'should only let one operator join the chat', (done) ->
    @newChat =>

      client = @getClient()
      client.ready =>
        client.login @guru1Login, (err, data) =>
          client.acceptChat @chatId, (err, result) =>
            false.should.eql err?
            result.status.should.eql "OK"
            client.disconnect()

            @getAuthed =>
              @client.acceptChat @chatId, (err, result) =>
                false.should.eql err?
                result.status.should.eql "ALREADY ACCEPTED"
                done()
