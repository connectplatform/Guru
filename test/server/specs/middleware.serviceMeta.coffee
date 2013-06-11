should = require 'should'

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
        err.toString().should.eql "login requires 'email' to be defined."
        done()

    it 'should err on invalid type', (done) ->
      @client.login {email: []}, (err, user) ->
        should.exist err
        err.should.eql "login requires 'email' to be a valid String."
        done()
