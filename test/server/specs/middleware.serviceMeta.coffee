should = require 'should'
stoic = require 'stoic'

boiler 'Middleware - Service Meta', ->

  beforeEach (done) ->
    @client = @getClient()
    @client.ready -> done()

  describe 'service with required fields', ->
    it 'should pass valid signature', (done) ->
      @client.login {email: 'owner@foo.com', password: 'foobar'}, (err, user) ->
        should.not.exist err
        should.exist user
        done()

    it 'should err on missing fields', (done) ->
      @client.login {}, (err, user) ->
        should.exist err
        err.should.eql 'Argument Required: email'
        done()

    it 'should err on invalid type', (done) ->
      @client.login {email: []}, (err, user) ->
        should.exist err
        err.should.eql "Argument Validation: 'email' must be a valid String."
        done()


  describe 'accountId lookup', ->
    it 'should err without sessionId', (done) ->
      @client = @getClient()
      @client.ready =>
        @client.getChatStats {}, (err, stats) =>
          should.exist err
          err.should.eql 'Argument Required: {sessionId: sessionId}'
          done()

    it 'should work with sessionId', (done) ->
      @ownerLogin (err, @client) =>
        @client.getChatStats {}, (err, stats) =>
          should.not.exist err
          should.exist stats
          done()
