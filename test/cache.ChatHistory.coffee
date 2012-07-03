boiler = require './util/boilerplate'
redis = require '../server/redis'
should = require 'should'

boiler 'Cache - ChatHistory', (globals) ->
  it 'saves and retrieves', (done) ->
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