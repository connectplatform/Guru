require 'should'
boiler = require './util/boilerplate'
redis = require '../server/redis'
redgoose = require 'redgoose'

boiler 'Service - Join Chat', ->

  it 'should associate an operator with a chat', (done) ->
    loginData =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    # visitor starts a new chat
    @client.newChat {username: 'foo'}, (err, data) =>
      channel = @client.cookie 'channel'

      # operator logs in
      operatorClient = @getClient()
      operatorClient.ready ->
        operatorClient.login loginData, (err, data) ->

          # operator joins chat channel
          operatorClient.joinChat channel, (err, data) ->
            false.should.eql err?
            id = operatorClient.cookie('session')

            #TODO: move everything below this into a unit test
            {Operator} = redgoose.models

            # ensure the chat channel was saved in redis
            Operator.get(id).chats.all (err, data) ->
              false.should.eql err?
              data.should.includeEql channel

              # ensure that the operator was added to the channel in redis
              redis.chats.operators channel, (err, data) ->
                false.should.eql err?
                data.should.includeEql id
                operatorClient.disconnect()
                done()
