require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Watch Chat', ->

  #TODO add test that shows that this operator can't post in pulsarChannel
  it 'should let an operator view a chat', (done) ->

    #given
    visitorClient = @getClient()
    visitorClient.ready =>
      visitorClient.newChat {username: 'foo'}, (err, {channel}) =>
        sessionId = visitorClient.cookie 'session'
        visitorClient.refresh =>
          visitorClient.disconnect()
          message = "hello, world!"

          pulsarChannel = @getPulsar().channel channel
          pulsarChannel.emit 'clientMessage', {message: message, session: sessionId}

          #when
          @getAuthed =>
            @client.watchChat channel, (err, data) =>
              false.should.eql err?
              @client.getChatHistory channel, (err, data)=>
                false.should.eql err?

                #expect
                data[0].username.should.eql 'foo'
                data[0].message.should.eql message
                done()