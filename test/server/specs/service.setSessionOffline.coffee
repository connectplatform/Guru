should = require 'should'
db = config.require 'load/mongo'
{Session} = db.models

boiler 'Service - Set Session Offline', ->

  it 'should set you as offline', (done) ->

    @ownerLogin (err, @client, {accountId, sessionId}) =>
      should.not.exist err

      Session.findById sessionId, (err, session) =>
        should.not.exist err
        should.exist session
        session.online.should.equal true, "wasn't set online at login"

        @client.setSessionOffline {}, =>
          Session.findById sessionId, (err, session) =>
            should.not.exist err
            should.exist session
            session.online.should.equal false, "wasn't set offline at logout"
            done()
