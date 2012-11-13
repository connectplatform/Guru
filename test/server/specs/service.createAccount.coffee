should = require 'should'

fields =
  email: 'bob@example.com'
  firstName: 'Bob'
  lastName: 'Smith'
  password: 'foobar'

boiler 'Service - Save Account', ->

  describe 'with valid info', ->

    it 'should create an account and log me in', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.createAccount fields, (err, status) =>
          should.not.exist err
          should.exist @client.cookie('session'), 'expected to be logged in'
          done()
