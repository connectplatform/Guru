should = require 'should'
stoic = require 'stoic'

loginData =
  email: 'admin@foo.com'
  password: 'foobar'

boiler 'Service - Set Session Offline', ->

  it 'should log you out', (done) ->

    @client = @getClient()
    @client.ready =>
      @client.login loginData, (err, userInfo) =>
        should.not.exist err
        id = @client.cookie 'session'

        {Session} = stoic.models
        Session.get(id).online.get (err, online) =>
          should.not.exist err
          online.should.eql true, "wasn't set online at login"

          @client.setSessionOffline @client.cookie('session'), =>
            Session.get(id).online.get (err, online) =>
              should.not.exist err
              online.should.eql false, "wasn't set offline at logout"
              @client.disconnect()
              done()
