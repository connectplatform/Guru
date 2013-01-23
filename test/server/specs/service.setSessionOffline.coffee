should = require 'should'
stoic = require 'stoic'

boiler 'Service - Set Session Offline', ->

  it 'should set you as offline', (done) ->

    @ownerLogin (err, @client, {accountId, sessionId}) =>
      should.not.exist err

      {Session} = stoic.models
      Session(accountId).get(sessionId).online.get (err, online) =>
        should.not.exist err
        online.should.eql true, "wasn't set online at login"

        @client.setSessionOffline {}, =>
          Session(accountId).get(sessionId).online.get (err, online) =>
            should.not.exist err
            online.should.eql false, "wasn't set offline at logout"
            done()
