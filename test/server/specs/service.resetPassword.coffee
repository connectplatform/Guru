should = require 'should'

loginData =
  email: 'admin@foo.com'
  password: "newPassword"

boiler 'Service - Reset Password', ->

  it 'should let a user reset their password', (done) ->
    {_id, registrationKey} = @adminUser

    client = @getClient()
    client.ready ->

      # reset password
      client.resetPassword _id, registrationKey, loginData.password, (err) =>
        should.not.exist err, "expected resetPassword to work: #{err}"

        # try to log in with new password
        client.login loginData, (err, user) =>
          should.not.exist err, "expected login to work: #{err}"

          # verify that login worked
          user.email.should.eql loginData.email
          client.disconnect()
          done()
