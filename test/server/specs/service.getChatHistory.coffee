should = require 'should'

boiler 'Service - Get Chat History', ->

  it 'should return the history of a chat', (done) ->
    @client = @getClient()
    @client.ready =>
      username = 'historyVisitor'
      data = {username: username}
      @client.newChat data, (err, {channel}) =>
        sessionId = @client.cookie 'session'
        pulsar = @getPulsar()

        pulsarChannel = pulsar.channel channel
        message0 = "first message"
        message1 = "second message"
        outgoing0 = {session: sessionId, message: message0}
        outgoing1 = {session: sessionId, message: message1}
        outgoing2 = {session: sessionId, message: 'done'}
        pulsarChannel.emit 'clientMessage', outgoing0
        pulsarChannel.emit 'clientMessage', outgoing1

        pulsarChannel.on 'serverMessage', (data) =>
          if data.message is 'done'
            @client.getChatHistory channel, (err, data) =>
              @client.disconnect()
              false.should.eql err?
              data[0].username.should.eql username
              data[1].username.should.eql username
              data[0].message.should.eql message0
              data[1].message.should.eql message1
              data[0].timestamp.should.exist
              data[1].timestamp.should.exist
              done()

        pulsarChannel.emit 'clientMessage', outgoing2
