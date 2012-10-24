should = require 'should'
stoic = require 'stoic'

boiler 'Service - Set Session Offline', ->

  it 'should set you as offline', (done) ->

    @adminLogin (err, @client, accountId) =>
      should.not.exist err
      id = @client.cookie 'session'

      {Session} = stoic.models
      Session(accountId).get(id).online.get (err, online) =>
        should.not.exist err
        online.should.eql true, "wasn't set online at login"

        @client.setSessionOffline @client.cookie('session'), =>
          Session(accountId).get(id).online.get (err, online) =>
            should.not.exist err
            online.should.eql false, "wasn't set offline at logout"
            done()
