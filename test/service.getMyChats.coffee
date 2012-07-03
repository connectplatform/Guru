require 'should'
boiler = require './util/boilerplate'
redisFactory = require '../server/redis'

boiler 'Service - Get My Chats', (globals) ->

  it 'should associate an operator with a chat', (done)->
    loginData =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    visitorClient = globals.getClient()
    visitorClient.ready ->
      visitorClient.newChat {username: 'foo'}, (err, data)->
        channel = visitorClient.cookie 'channel'
        visitorClient.disconnect()
        operatorClient = globals.getClient()
        operatorClient.ready ->
          operatorClient.login loginData, (err, data)->
            operatorClient.joinChat channel, (err, data)->
              false.should.eql err?
              redisFactory (redis)->
                id = operatorClient.cookie('session')
                redis.operators.chats id, (err, data)->
                  false.should.eql err?
                  {inspect} = require 'util'
                  data.should.includeEql channel
                  redis.chats.operators channel, (err, data)->
                    false.should.eql err?
                    data.should.includeEql id
                    operatorClient.disconnect()
                    done()