require 'should'
seed = require './util/seedMongo'
boiler = require './util/boilerplate'

boiler 'Service - Get Active Chats', (globals) ->

  beforeEach (done)->
    seed done

  it 'should exist', (done) ->
    client = globals.getClient()
    client.ready (services) ->
      services.should.include 'getActiveChats'
      client.disconnect()
      done()

  it 'should return data on all existing chats', (done)->
    client = globals.getClient()
    client.ready ->
      data = {username: 'foo'}
      client.newChat data, (err, data)->
        client.disconnect()

        loginData =
          email: 'god@torchlightsoftware.com'
          password: 'foobar'
        client2 = globals.getClient()
        client2.ready ->
          client2.login loginData, ->
            client2.getActiveChats (err, data)->
              client2.disconnect()
              false.should.eql err?
              chatData = data[0]
              {inspect} = require 'util'
              chatData.visitor.username.should.eql 'foo'
              chatData.visitorPresent.should.eql true
              new Date chatData.creationDate #just need this to not cause an error
              done()