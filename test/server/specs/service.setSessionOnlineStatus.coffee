should = require 'should'
async = require 'async'

boiler 'Service - Set Session Online Status', ->

  it 'should control your online status', (done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'
    should.exist setSessionOnlineStatus

    @getAuthed (err, client, {sessionId, sessionSecret}) =>
      should.not.exist err
      should.exist sessionId
      should.exist sessionSecret

      check = (status) =>
        (cb) =>
          data =
            sessionSecret: sessionSecret
            isOnline: status
          setSessionOnlineStatus data, (err) =>
            should.not.exist err
            @expectSessionIsOnline sessionId, status, cb

      async.series [
        check false
        check true
        check false
      ], done
