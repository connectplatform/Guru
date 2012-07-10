require 'should'
boiler = require './util/boilerplate'
seed = require './util/seedMongo'

boiler 'Service - Get Chat History', ->

  it 'should return the history of a chat', (done) ->
    username = 'historyVisitor'
    data = {username: username}
    @client.newChat data, (err, data) =>
      @client.refresh (services) =>
        channelName = @client.cookie 'channel'
        sessionId = @client.cookie 'session'
        pulsar = @getPulsar()

        channel = pulsar.channel channelName
        message0 = "first message"
        message1 = "second message"
        outgoing0 = {session: sessionId, message: message0}
        outgoing1 = {session: sessionId, message: message1}
        outgoing2 = {session: sessionId, message: 'done'}
        channel.emit 'clientMessage', outgoing0
        channel.emit 'clientMessage', outgoing1

        channel.on 'serverMessage', (data) =>
          if data.message is 'done'
            @client.getChatHistory channelName, (err, data) =>
              false.should.eql err?
              data[0].username.should.eql username
              data[1].username.should.eql username
              data[0].message.should.eql message0
              data[1].message.should.eql message1
              data[0].timestamp.should.exist
              data[1].timestamp.should.exist
              done()

        channel.emit 'clientMessage', outgoing2
