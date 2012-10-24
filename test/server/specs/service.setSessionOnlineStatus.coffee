should = require 'should'

boiler 'Service - Set Session Online Status', ->

  it 'should control your online status', (done) ->
    setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

    @getAuthed (err, userInfo) =>
      id = @client.cookie 'session'

      setSessionOnlineStatus id, false, =>
        @expectSessionIsOnline id, false, =>

        setSessionOnlineStatus id, true, =>
          @expectSessionIsOnline id, true, =>

          setSessionOnlineStatus id, false, =>
            @expectSessionIsOnline id, false, =>

              @client.disconnect()
              done()
