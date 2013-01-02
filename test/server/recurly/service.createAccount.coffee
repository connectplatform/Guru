should = require 'should'

fields =
  email: 'bob@example.com'
  firstName: 'Bob'
  lastName: 'Smith'
  password: 'foobar'

boiler 'Service - Create Account', ->

  describe 'with valid info', ->

    it 'should create an account and log me in', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.createAccount fields, (err, status) =>
          should.not.exist err
          should.exist @client.cookie('session'), 'expected to be logged in'
          done()

    it 'should not allow duplicate emails', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.createAccount Sample.owner, (err, status) =>
          should.exist err
          err.should.eql 'A user with that email already exists.'
          done()
