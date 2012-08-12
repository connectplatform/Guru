should = require 'should'
boiler = require './util/boilerplate'
db = require '../server/mongo'
{User} = db.models
{digest_s} = require 'md5'

boiler 'Model - Operator Chat', ->

  it 'should not let you save an invalid role', (done)->
    user =
      email: 'invalidrole@foo.com'
      password: digest_s 'foobar'
      role: 'Invalid'
      firstName: 'First'
      lastName: 'Guru'

    User.create user, (err, data) ->
      err.message.should.eql "Validation failed"
      done()

  it 'should gracefully call back with an error if you leave a required field blank', (done)->
    user =
      password: digest_s 'foobar'
      email: "jkl@foo.com"
      firstName: 'First'
      lastName: 'Guru'

    @getAuthed =>
      @client.saveModel user, "User", (err, savedModel) ->
        err.should.eql 'Validator "required" failed for path role\n'
        done()
