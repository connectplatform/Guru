should = require 'should'

loginData =
  email: 'owner@foo.com'
  password: "newPassword"

boiler 'Service - Reset Password', ->

  it 'should let a user reset their password', (done) ->
    {_id, registrationKey} = @ownerUser

    client = @getClient()
    client.ready ->

      # reset password
      client.resetPassword {userId: _id, registrationKey: registrationKey, newPassword: loginData.password}, (err) =>
        should.not.exist err, "expected resetPassword to work: #{err}"

        # try to log in with new password
        client.login loginData, (err, {sessionId}) =>
          should.not.exist err, "expected login to work: #{err}"
          should.exist sessionId, "expected sessionId"
          done()
