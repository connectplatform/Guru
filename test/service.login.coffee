require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    data =
      email: 'god@torchlightsoftware.com'
      password: 'foobar'

    @client.login data, (err, data) =>
      false.should.eql err?
      id = @client.cookie('session')

      {Session} = redgoose.models
      Session.get(id).chatName.get (err, data) ->
        false.should.eql err?
        data.should.eql "God"
        done()
