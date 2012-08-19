should = require 'should'
boiler = require './util/boilerplate'
stoic = require 'stoic'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    loginData =
      email: 'admin@foo.com'
      password: 'foobar'

    @client.login loginData, (err, userInfo) =>
      should.not.exist err
      id = @client.cookie('session')

      {Session} = stoic.models
      Session.get(id).chatName.get (err, chatName) ->
        should.not.exist err
        chatName.should.eql "Admin"
        done()
