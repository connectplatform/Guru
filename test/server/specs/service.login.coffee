should = require 'should'
stoic = require 'stoic'

loginData =
  email: 'admin@foo.com'
  password: 'foobar'

login = (client, cb) ->
    cb()

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @client = @getClient()
    @client.ready =>
      @client.login loginData, (err, userInfo) =>
        should.not.exist err
        sessionId = @client.cookie 'session'

        {Session} = stoic.models
        Session.get(sessionId).chatName.get (err, chatName) =>
          should.not.exist err
          chatName.should.eql "Admin Guy"
          @client.disconnect()
          done()

  it 'should reattatch you to an existing session', (done) ->
    @client = @getClient()
    @client.ready =>

      @client.login loginData, (err) =>
        sessionId = @client.cookie 'session'

        @client.logout (err) =>
          should.not.exist err

          console.log 'about to relogin'
          @client.login loginData, (err) =>
            console.log 'logged in'
            should.not.exist err

            sessionId.should.eql @client.cookie 'session'

            {Session} = stoic.models
            console.log 'about to get online status'
            Session.get(sessionId).online.get (err, online) =>
              console.log 'got online status'
              should.not.exist err
              online.should.eql true
              @client.disconnect()
              done()
