should = require 'should'
forgotPassword = config.require 'services/forgotPassword'

email = 'guru1@foo.com'
badEmail = 'foo@bar.com'

boiler 'Service - Forgot Password', ->

  it 'should let a user reset their password', (done) ->
    client = @getClient()
    client.ready ->

      client.forgotPassword {email: email}, (err, {status}) ->
        should.not.exist err
        status.should.eql 'OK'
        client.disconnect()
        done()

  it 'should fail gracefully when email not found', (done) ->
    client = @getClient()
    client.ready ->

      client.forgotPassword {email: badEmail}, (err, status) ->
        should.exist err
        err.should.eql 'Could not find user.'
        client.disconnect()
        done()
