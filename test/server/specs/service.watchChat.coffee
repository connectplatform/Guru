should = require 'should'
stoic = require 'stoic'

boiler 'Service - Watch Chat', ->

  #TODO add test that shows that this operator can't post in pulsarChannel
  it 'should let an operator view a chat', (done) ->

    #given
    @getAuthed =>
      visitorClient = @getClient()
      visitorClient.ready =>
        visitorClient.newChat {username: 'foo', websiteUrl: 'foo.com'}, (err, data) =>
          should.not.exist err
          {chatId} = data
          sessionId = visitorClient.cookie 'session'
          visitorClient.ready =>
            visitorClient.disconnect()
            message = "hello, world!"

            pulsarChannel = @getPulsar().channel chatId
            pulsarChannel.emit 'clientMessage', {message: message, session: sessionId}

            #when
            @client.watchChat chatId, (err, data) =>
              false.should.eql err?
              @client.getChatHistory chatId, (err, data)=>
                false.should.eql err?

                #expect
                data[0].username.should.eql 'foo'
                data[0].message.should.eql message
                done()
