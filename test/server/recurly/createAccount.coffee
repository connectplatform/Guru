should = require 'should'
{inspect} = require 'util'
{setTimeout} = require 'timers'


boiler 'Recurly - Create Account', ->
  before ->
    @createRecurlyAccount = config.service 'recurly/createAccount'

  describe 'with valid data', ->
    beforeEach (done) ->
      @createRecurlyAccount {accountId: @account._id}, (err, @result) =>
        should.not.exist err, "Create account returned an error: #{err}\n#{inspect @result, false, 10}"
        done()

    it 'should return success', (done) ->
      @result.status.should.eql 201
      done()

  describe 'with duplicate accountId', ->
    it 'should return error', (done) ->
      @createRecurlyAccount {accountId: @account._id}, (err) =>
        should.not.exist err
        
        @createRecurlyAccount {accountId: @account._id}, (err, @result) =>
          should.exist err, 'expected error'
          should.exist @result
          @result.errors.error.value.should.eql 'has already been taken'
          done()

  describe 'with invalid data', ->
    it 'should return error', (done) ->
      @createRecurlyAccount {accountId: 'foo'}, (err, @result) =>
        should.exist err, "create account should return error"
        err.message.should.eql "recurly/createAccount requires 'accountId' to be a valid MongoId."
        done()
