should = require 'should'

boiler 'Policy - Middleware', ->
  it 'should block users from performing forbidden actions', (done) ->
    @client = @getClient()
    @client.ready =>
      @client.deleteModel 'some_id', 'Website', (err) ->
        err.error.should.eql 'expects cookie: {session: sessionId}'
        done()
