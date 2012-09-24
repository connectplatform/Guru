should = require 'should'
stoic = require 'stoic'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @client = @getClient()
    @client.ready =>
      @client.login @adminLogin, (err, userInfo) =>
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

      @client.login @adminLogin, (err) =>
        sessionId = @client.cookie 'session'

        @client.setSessionOffline @client.cookie('session'), (err) =>
          should.not.exist err

          @client.login @adminLogin, (err) =>
            should.not.exist err

            sessionId.should.eql @client.cookie 'session'

            {Session} = stoic.models
            Session.get(sessionId).online.get (err, online) =>
              should.not.exist err
              online.should.eql true
              @client.disconnect()
              done()
