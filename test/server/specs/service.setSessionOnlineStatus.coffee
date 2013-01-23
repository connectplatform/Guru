should = require 'should'
async = require 'async'

boiler 'Service - Set Session Online Status', ->

  it 'should control your online status', (done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'

    @getAuthed (err, userInfo) =>

      check = (status) =>
        (cb) => setSessionOnlineStatus {sessionId: @sessionId, isOnline: status}, =>
          @expectSessionIsOnline @sessionId, status, cb

      async.series [
        check false
        check true
        check false
      ], done
