should = require 'should'
db = config.require 'server/load/mongo'
{Account, User} = db.models

boiler 'Model - User', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      done err

  it 'should let you save an Owner', (done) ->
    user =
      accountId: @accountId
      email: 'owner2@foo.com'
      password: 'foobar'
      role: 'Owner'
      firstName: 'First'
      lastName: 'Owner'

    User.create user, (err, data) ->
      should.not.exist err
      data.email.should.eql 'owner2@foo.com'
      done()

  it 'should let you save a valid user', (done) ->
    user =
      accountId: @accountId
      email: 'operator1@foo.com'
      password: 'foobar'
      role: 'Operator'
      firstName: 'First'
      lastName: 'Operator'

    User.create user, (err, data) ->
      should.not.exist err
      data.email.should.eql 'operator1@foo.com'
      done()

  it 'should not let you save an invalid role', (done) ->
    user =
      accountId: @accountId
      email: 'invalidrole@foo.com'
      password: 'foobar'
      role: 'Invalid'
      firstName: 'First'
      lastName: 'Guru'

    User.create user, (err, data) ->
      err.message.should.eql 'Validation failed'
      done()

  it 'should not let you change an Owner to an Operator', (done) ->
    User.findOne {role: 'Owner'}, (err, user) ->
      user.role = 'Operator'
      user.save (err, data) ->
        should.exist err
        err.message.should.eql 'Cannot change Owner role.'
        done()

  it 'should gracefully call back with an error if you leave a required field blank', (done) ->
    user =
      accountId: @accountId
      password: 'foobar'
      email: "jkl@foo.com"
      firstName: 'First'
      lastName: 'Guru'

    @getAuthed =>
      @client.saveModel {fields: user, modelName: 'User'}, (err, savedModel) ->
        err.should.eql 'Validator "required" failed for path role\n'
        done()
