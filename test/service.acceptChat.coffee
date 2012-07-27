require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Accept Chat', ->

  it 'should join the operator into the chat', (done) ->
    @newChat =>
      @getAuthed =>
        @client.acceptChat @channelName, (err, result) =>
          false.should.eql err?
          result.status.should.eql "OK"
          result.chatId.should.eql @channelName

          #Try to post in channel
          outgoing =
            session: @client.cookie 'session'
            message: 'accept chat worked'

          @channel.on 'serverMessage', (data)->
            data.message.should.eql outgoing.message
            done()

          # send test data
          @channel.emit 'clientMessage', outgoing

  it 'should only let one operator join the chat', (done) ->
    @newChat =>

      loginData =
        email: 'guru1@foo.com'
        password: 'foobar'

      client = @getClient()
      client.ready =>
        client.login loginData, (err, data) =>
          client.acceptChat @channelName, (err, result) =>
            false.should.eql err?
            result.status.should.eql "OK"
            client.disconnect()

            @getAuthed =>
              @client.acceptChat @channelName, (err, result) =>
                false.should.eql err?
                result.status.should.eql "ALREADY ACCEPTED"
                done()
