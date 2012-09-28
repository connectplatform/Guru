should = require 'should'

boiler 'Service - Set Session Online Status', ->

  it 'should control your online status', (done) ->
    setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

    @client = @getClient()
    @client.ready =>
      @client.login @adminLogin, (err, userInfo) =>
        id = @client.cookie 'session'

        setSessionOnlineStatus id, false, =>
          @expectIdIsOnline id, false, =>

          setSessionOnlineStatus id, true, =>
            @expectIdIsOnline id, true, =>

            setSessionOnlineStatus id, false, =>
              @expectIdIsOnline id, false, =>

                @client.disconnect()
                done()
