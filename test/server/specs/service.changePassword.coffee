should = require 'should'

boiler 'Service - Change Password', ->
  before ->
    @changePassword = (cb) =>
      @ownerLogin (err, client) =>
        should.not.exist err

        # change password
        client.changePassword {oldPassword: "foobar", newPassword: "newPassword"}, (err) =>
          should.not.exist err

          # log out
          client.disconnect()
          cb()

  it 'should let a user log in with a changed password', (done) ->
    @changePassword =>

      # try to log in with new password
      newLogin =
        email: 'owner@foo.com'
        password: "newPassword"

      @getAuthedWith newLogin, (err, client) =>
        should.not.exist err

        # verify that login worked
        should.exist client.cookie 'session'

        client.disconnect()
        done()

  it 'should not let you log in with an old password once its been changed', (done) ->
    @changePassword =>

      # try to log in with old password
      @ownerLogin (err, client) =>

        # verify that login failed
        err.should.eql "Invalid user or password."
        should.not.exist client.cookie 'session'
        client.disconnect()
        done()
