should = require 'should'

boiler 'Service - Change Password', ->

  before ->
    @changePassword = (client, cb) =>
      loginData =
        email: 'admin@foo.com'
        password: 'foobar'
      client.login loginData, (err, user) =>
        should.not.exist err
        @emailLoggedInAs = user.email
        client.changePassword "foobar", "newPassword", (err) =>
          should.not.exist err
          #log out
          client.cookie "session", null
          cb()

  it 'should let a user log in with a changed password', (done) ->
    client = @getClient()
    client.ready =>
      @changePassword client, =>
        #try to log in with new password
        loginData =
          email: 'admin@foo.com'
          password: "newPassword"
        client.login loginData, (err, user) =>
          should.not.exist err

          #verify that login worked
          user.email.should.eql @emailLoggedInAs
          client.disconnect()
          done()

  it 'should not let you log in with an old password once its been changed', (done) ->
    client = @getClient()
    client.ready =>
      @changePassword client, =>
        #try to log in with old password
        loginData =
          email: 'admin@foo.com'
          password: "foobar"
        client.login loginData, (err, user) =>

          #verify that login failed
          err.should.eql "Invalid user or password."
          should.not.exist user
          client.disconnect()
          done()
