boiler = require './util/boilerplate'
redisFactory = require '../server/redis'
should = require 'should'

boiler 'Cache - ChatHistory', (globals) ->
  it 'saves and retrieves', (done) ->
    redisFactory (redis)->
      redis.chats.create (id)->
        input = {name: "Brandon", timestamp: new Date, message: "Hello!"}
        redis.chats.addMessage id, input, ->
          redis.chats.history id, (err, data)->
            false.should.eql err?
            data[0].should.eql JSON.parse JSON.stringify input
            redis.chats.getChatIds (err, data)->
              false.should.eql err?
              data.should.includeEql id
            done()