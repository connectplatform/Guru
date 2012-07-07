require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Join Chat', ->

  it 'should associate an operator with a chat', (done) ->
    loginData =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    visitorClient = @getClient()
    visitorClient.ready =>
      visitorClient.newChat {username: 'foo'}, (err, data) =>
        channel = visitorClient.cookie 'channel'
        visitorClient.disconnect()
        operatorClient = @getClient()
        operatorClient.ready ->
          operatorClient.login loginData, (err, data) ->
            operatorClient.joinChat channel, (err, data) ->
              false.should.eql err?
              id = operatorClient.cookie('session')

              #TODO refactor this to check at a higher level than cache contents
              {OperatorChat} = redgoose.models
              OperatorChat.getChatsByOperator id, (err, data) ->

                false.should.eql err?
                data[channel].should.eql 'false'
                OperatorChat.getOperatorsByChat channel, (err, data)->
                  false.should.eql err?
                  data[id].should.eql 'false'
                  operatorClient.disconnect()
                  done()
