should = require 'should'
forgotPassword = config.require 'services/forgotPassword'

email = 'guru1@foo.com'
badEmail = 'foo@bar.com'

boiler 'Service - Forgot Password', ->

  it 'should let a user reset their password', (done) ->
    client = @getClient()
    client.ready ->

      client.forgotPassword {email: email}, (err, {result}) ->
        should.not.exist err
        result.should.eql 'sentEmail'
        done()

  it 'should fail gracefully when email not found', (done) ->
    client = @getClient()
    client.ready ->

      client.forgotPassword {email: badEmail}, (err, {result}) ->
        should.exist err
        err.should.eql 'Could not find user.'
        done()
