require 'should'
boiler = require './util/boilerplate'
seed = require './util/seedMongo'
redisFactory = require '../server/redis'

boiler 'Service - Login', (globals) ->

  it 'should exist', (done) ->
    client = globals.getClient()
    client.ready (services) ->
      services.should.include 'login'
      client.disconnect()
      done()

  it 'should log you in', (done)->
    data =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    client = globals.getClient()
    client.ready ->
      client.login data, (err, data)->
        client.disconnect()
        false.should.eql err?
        redisFactory (redis)->
          id = client.cookie('session')
          redis.sessions.chatName id, (err, data)->
            false.should.eql err?
            data.should.eql "God"
            done()