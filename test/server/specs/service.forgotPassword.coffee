should = require 'should'
forgotPassword = config.require 'services/forgotPassword'

email = 'guru1@foo.com'

boiler 'Service - Reset Password', ->

  it 'should let a user reset their password', (done) ->
    client = @getClient()
    client.ready ->

      client.forgotPassword email, (err, status) ->
        should.not.exist err
        should.exist status
        status.should.eql 'Success! Please check your email for reset instructions.'
        client.disconnect()
        done()
