require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', ->

  it 'should let you interact with the server', (done) ->
    data = {username: 'clientTest1'}
    @client.newChat data, (err, data) =>
      throw err if err
      @client.refresh =>

        # listen for response
        @client.subscribe[data.channel] (err, data) =>
          data.message.should.eql 'hello from the test' if data.username is 'clientTest1'
          done()

        # send signal
        @client[data.channel] 'hello from the test', (err, data) ->
          false.should.eql err?
