should = require 'should'

boiler 'Service - Get Relation to Chat', ->
  it 'it should not return an error when the sessionSecret and sessionId match', (done) ->
    @guru1Login (err, @guru1, {sessionSecret, sessionId}) =>
      config.services['filters/sessionIdMatchesSecret'] {sessionSecret, sessionId}, (err) =>
        should.not.exist err
        done()

  it 'should return an error when the sessionSecret and sessionId do not match', (done) ->
    @guru1Login (err, @guru1, {sessionSecret}) =>
      @guru2Login (err, @guru2, {sessionId}) =>
        config.services['filters/sessionIdMatchesSecret'] {sessionSecret, sessionId}, (err) =>
          should.exist err
          err.should.equal 'sessionId and sessionSecret must belong to same Session'
          done()
