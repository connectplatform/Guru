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

              {Operator, Chat} = redgoose.models
              Operator.get(id).chats.all (err, data) ->

                false.should.eql err?
                data.should.includeEql channel
                Chat.get(channel).operators.all (err, data)->
                  false.should.eql err?
                  data.should.includeEql id
                  operatorClient.disconnect()
                  done()
