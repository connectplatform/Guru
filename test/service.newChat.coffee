require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', ->

  it 'should let you interact with the server', (done) ->
    data = {username: 'clientTest1'}
    @client.newChat data, (err, data) =>
      throw err if err
      @client.refresh =>

        session = @client.cookie 'session'
        channel = @getPulsar().channel data.channel

        channel.on 'serverMessage', (data)->
          data.message.should.eql 'hello from the test'
          data.username.should.eql 'clientTest1'
          done()

        outgoing =
          session: session
          message: 'hello from the test'
        
        channel.emit 'clientMessage', outgoing