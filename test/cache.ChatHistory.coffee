boiler = require './util/boilerplate'
redback = require '../server/redis'
{createChatHistory} = redback

{inspect} = require 'util'
should = require 'should'

boiler 'Cache - ChatHistory', (globals) ->

  it 'saves and retrieves', (done) ->
    chat = createChatHistory 'default'
    input = {name: "Brandon", timestamp: new Date, message: "Hello!"}

    chat.push input, (err, data) ->
      (!!err).should.be.false
      data.should.be.a('object')

      chat.get (err, data) ->
        (!!err).should.be.false
        # data should be [{name: "Brandon" ...}]
        done()

