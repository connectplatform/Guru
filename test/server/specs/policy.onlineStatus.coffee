should = require 'should'

boiler 'Policy - Online Status', ->
  it 'should set active operators as online', (done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'

    @guru1Login (err, @guru1, @guru1Data) =>
      should.not.exist err
      should.exist @guru1
      should.exist @guru1Data
      
      @expectSessionIsOnline @guru1Data.sessionId, true, (err) =>
        should.not.exist err
        
        setSessionOnlineStatus {sessionSecret: @guru1Data.sessionSecret, isOnline: false}, (err) =>
          should.not.exist err
          
          @expectSessionIsOnline @guru1Data.sessionId, false, =>
            done()
