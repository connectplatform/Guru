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
        channel = visitorClient.cookie 'channel'
        visitorClient.refresh =>
          message = "hello, world!"
          visitorClient[channel] message, (err, data) =>
            visitorClient.disconnect()

            operatorClient = @getClient()
            operatorClient.ready ->

              operatorClient.getChatHistory channel, (err, data)->

                #when
                operatorClient.login loginData, (err, data) ->
                  operatorClient.watchChat channel, (err, data) ->
                    false.should.eql err?
                    operatorClient.getChatHistory channel, (err, data)->
                      operatorClient.disconnect()
                      false.should.eql err?

                      #expect
                      data[0].username.should.eql 'foo'
                      data[0].message.should.eql message
                      done()