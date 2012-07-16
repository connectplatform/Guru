should = require 'should'
boiler = require './util/boilerplate'
db = require '../server/mongo'
{User} = db.models
{digest_s} = require 'md5'

boiler 'Model - Operator Chat', ->

  it 'should not let you save an invalid role', (done)->
    user =
      email: 'invalidrole@torchlightsoftware.com'
      password: digest_s 'foobar'
      role: 'Invalid'
      firstName: 'First'
      lastName: 'Guru'

    User.create user, (err, data) ->
      err.message.should.eql "Validation failed"
      done()