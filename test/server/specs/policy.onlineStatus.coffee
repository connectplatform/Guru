should = require 'should'

boiler 'Policy - Online Status', ->
  it 'should set active operators as online', (done) ->
    setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

    @client = @getClient()
    @client.ready =>

      # logging in should set us as online
      @getAuthed =>
        sessionId = @client.cookie 'session'
        @expectSessionIsOnline sessionId, true, =>

          # other actions should set us as online

          # pretend we navigated away
          setSessionOnlineStatus sessionId, false, =>

            @client.getActiveChats (err, chats) =>
              @expectSessionIsOnline sessionId, true, =>
                done()
