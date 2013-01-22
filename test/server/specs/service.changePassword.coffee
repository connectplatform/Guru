should = require 'should'

boiler 'Service - Change Password', ->
  before ->
    @changePassword = (cb) =>
      @ownerLogin (err, client) =>
        should.not.exist err, 'initial login failed'

        # change password
        client.changePassword {sessionId: @sessionId, oldPassword: "foobar", newPassword: "newPassword"}, (err) =>
          should.not.exist err, 'change password failed'

          # log out
          client.disconnect()
          cb()

  it 'should let a user log in with a changed password', (done) ->
    @changePassword =>

      # try to log in with new password
      newLogin =
        email: 'owner@foo.com'
        password: "newPassword"

      @getAuthedWith newLogin, (err, client, {sessionId}) =>
        should.not.exist err, 'login with new password failed'

        # verify that login worked
        should.exist sessionId

        client.disconnect()
        done()

  it 'should not let you log in with an old password once its been changed', (done) ->
    @changePassword =>

      # try to log in with old password
      @ownerLogin (err, client, {sessionId}) =>

        # verify that login failed
        err.should.eql "Invalid password."
        should.not.exist sessionId
        client.disconnect()
        done()
