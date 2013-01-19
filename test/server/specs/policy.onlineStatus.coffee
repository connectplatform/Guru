should = require 'should'

boiler 'Policy - Online Status', ->
  it 'should set active operators as online', (done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'

    @client = @getClient()
    @client.ready =>

      # logging in should set us as online
      @getAuthed =>
        @expectSessionIsOnline @sessionId, true, =>

          # pretend we navigated away
          setSessionOnlineStatus {sessionId: @sessionId, isOnline: false}, (err) =>
            should.not.exist err, 'expected setSessionOnlineStatus to work'

            # other actions should set us as online
            @client.getActiveChats {sessionId: @sessionId}, (err, chats) =>
              should.not.exist err, 'expected getActiveChats to work'
              @expectSessionIsOnline @sessionId, true, =>
                done()
