require 'should'
boiler = require './util/boilerplate'
seed = require './util/seedMongo'
redgoose = require 'redgoose'

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
        id = client.cookie('session')

        {Session} = redgoose.models
        Session.get(id).chatName.get (err, data)->
          false.should.eql err?
          data.should.eql "God"
          done()