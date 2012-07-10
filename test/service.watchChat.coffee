require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Watch Chat', ->

  #TODO add test that shows that this operator can't post in channel
  it 'should let an operator view a chat', (done) ->
    loginData =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    #given
    visitorClient = @getClient()
    visitorClient.ready =>
      visitorClient.newChat {username: 'foo'}, (err, data) =>
        channelName = visitorClient.cookie 'channel'
        sessionId = visitorClient.cookie 'session'
        visitorClient.refresh =>
          visitorClient.disconnect()
          message = "hello, world!"

          channel = @getPulsar().channel channelName
          channel.emit 'clientMessage', {message: message, session: sessionId}

          @client.ready =>

            #when
            @client.login loginData, (err, data) =>
              @client.watchChat channelName, (err, data) =>
                false.should.eql err?
                @client.getChatHistory channelName, (err, data)=>
                  false.should.eql err?

                  #expect
                  data[0].username.should.eql 'foo'
                  data[0].message.should.eql message
                  done()