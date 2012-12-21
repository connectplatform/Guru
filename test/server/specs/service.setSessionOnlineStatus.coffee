should = require 'should'

boiler 'Service - Set Session Online Status', ->

  it 'should control your online status', (done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'

    @getAuthed (err, userInfo) =>
      id = @client.cookie 'session'

      setSessionOnlineStatus {sessionId: id, isOnline: false}, =>
        @expectSessionIsOnline id, false, =>

        setSessionOnlineStatus {sessionId: id, isOnline: true}, =>
          @expectSessionIsOnline id, true, =>

          setSessionOnlineStatus {sessionId: id, isOnline: false}, =>
            @expectSessionIsOnline id, false, =>

              @client.disconnect()
              done()
