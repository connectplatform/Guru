should = require 'should'

fields =
  email: 'bob@example.com'
  firstName: 'Bob'
  lastName: 'Smith'
  password: 'foobar'
  passwordConfirm: 'foobar'

boiler 'Service - Save Account', ->

  describe 'with valid info', ->

    it 'should create an account', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.createAccount fields: fields, (err, status) =>
          should.not.exist err
          should.exist status?.accountId, 'expected accountId'
          should.exist status?.userId, 'expected userId'
          done()
