require 'should'
boiler = require './util/boilerplate'
seed = require './util/seedMongo'
redisFactory = require '../server/redis'

boiler 'Service - Get Chat History', (globals) ->

  it 'should return the history of a chat', (done)->
    client = globals.getClient()
    client.ready ->
      username = 'historyVisitor'
      data = {username: username}
      client.newChat data, (err, data)->
        client.refresh (services)->
          channel = client.cookie 'channel'
          message0 = "hello, world!"
          message1 = "I'm talking"
          client[channel] message0, (err, data)->
            client[channel] message1, (err, data)->
              client.getChatHistory channel, (err, data)->
                client.disconnect()
                false.should.eql err?
                data[0].username.should.eql username
                data[1].username.should.eql username
                data[0].message.should.eql message0
                data[1].message.should.eql message1
                data[0].timestamp.should.exist
                data[1].timestamp.should.exist
                done()