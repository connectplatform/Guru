should = require 'should'
stoic = require 'stoic'

loginData =
  email: 'admin@foo.com'
  password: 'foobar'

boiler 'Service - Logout', ->

  it 'should log you out', (done) ->

    @client = @getClient()
    @client.ready =>
      @client.login loginData, (err, userInfo) =>
        should.not.exist err
        id = @client.cookie 'session'

        {Session} = stoic.models
        Session.get(id).online.get (err, online) =>
          should.not.exist err
          online.should.eql true

          @client.logout =>
            Session.get(id).online.get (err, online) =>
              should.not.exist err
              online.should.eql false
              @client.disconnect()
              done()
