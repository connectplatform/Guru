should = require 'should'

boiler 'Service - Accept Chat', ->

  it 'should join the operator into the chat', (done) ->
    @getAuthed =>
      @newChat =>
        @client.acceptChat {chatId: @chatId}, (err, result) =>
          should.not.exist err
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

  it 'should only let one operator accept the chat', (done) ->
    @guru1Login (err, client) =>

      @newChat (err, data) =>
        should.not.exist err
        should.exist data

        client.acceptChat {chatId: @chatId}, (err, result) =>
          should.not.exist err
          result.status.should.eql "OK"
          client.disconnect()

          @getAuthed =>
            @client.acceptChat {chatId: @chatId}, (err, result) =>
              false.should.eql err?
              result.status.should.eql "ALREADY ACCEPTED"
              done()

  it 'should decrement my waiting chats count', (done) ->
    @guru1Login (err, client) =>

      @newChat (err, data) =>
        should.not.exist err
        should.exist data

        client.acceptChat {chatId: @chatId}, (err, result) =>
          should.not.exist err
          result.status.should.eql "OK"

          client.getChatStats {}, (err, {unanswered}) ->
            should.not.exist err
            should.exist unanswered
            unanswered.length.should.eql 0, 'expected no unanswered chats'

            client.disconnect()
            done()
