should = require 'should'
db = config.require 'server/load/mongo'
{Account, User} = db.models
{digest_s} = require 'md5'

boiler 'Model - User', ->
  beforeEach (done) ->
    Account.create {status: 'Trial'}, (err, account) =>
      @accountId = account._id
      done err

  it 'should not let you save an invalid role', (done)->
    user =
      accountId: @accountId
      email: 'invalidrole@foo.com'
      password: digest_s 'foobar'
      role: 'Invalid'
      firstName: 'First'
      lastName: 'Guru'

    User.create user, (err, data) ->
      err.message.should.eql 'Validation failed'
      done()

  it 'should gracefully call back with an error if you leave a required field blank', (done)->
    user =
      accountId: @accountId
      password: digest_s 'foobar'
      email: "jkl@foo.com"
      firstName: 'First'
      lastName: 'Guru'

    @getAuthed =>
      @client.saveModel {fields: user, modelName: 'User'}, (err, savedModel) ->
        err.should.eql 'Validator "required" failed for path role\n'
        done()
