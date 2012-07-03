require 'should'
boiler = require './util/boilerplate'

boiler 'Service - New Chat', (globals) ->

  it 'should exist', (done) ->
    veinClient = globals.getClient()
    veinClient.ready (services) ->
      services.should.include 'newChat'
      veinClient.disconnect()
      done()

  it 'should let you interact with the server', (done)->
    client = globals.getClient()
    client.ready (services) ->
      data = {username: 'clientTest1'}
      client.newChat data, (err, data)->
        throw err if err
        client.refresh ->
          client.subscribe[data.channel] (err, data)->
            data.message.should.eql 'hello from the test' if data.username is 'clientTest1'
            client.disconnect()

            done()

          client[data.channel] 'hello from the test', (err, data)->
            false.should.eql err?