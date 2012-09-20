should = require 'should'
stoic = require 'stoic'

loginData =
  email: 'admin@foo.com'
  password: 'foobar'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @client = @getClient()
    @client.ready =>
      @client.login loginData, (err, userInfo) =>
        should.not.exist err
        id = @client.cookie('session')

        {Session} = stoic.models
        Session.get(id).chatName.get (err, chatName) =>
          should.not.exist err
          chatName.should.eql "Admin Guy"
          @client.disconnect()
          done()
