should = require 'should'
{inspect} = require 'util'

boiler 'Service - Create Recurly Account', ->
  before ->
    @createRecurlyAccount = config.service 'account/createRecurlyAccount'

  describe 'with valid data', ->
    beforeEach (done) ->
      @createRecurlyAccount {accountId: @account._id}, (err, @result) =>
        should.not.exist err, "Create account returned an error: #{err}\n#{inspect @result, false, 10}"
        done()

    it 'should return success', (done) ->
      @result.status.should.eql 201
      done()

  describe 'with duplicate accountId', ->
    it 'should error', (done) ->
      @createRecurlyAccount {accountId: @account._id}, =>
        @createRecurlyAccount {accountId: @account._id}, (err, @result) =>
          should.exist err, 'expected error'
          @result.errors.error._.should.eql 'has already been taken'
          done()

  describe 'with invalid data', ->

    it 'should return success', (done) ->
      @createRecurlyAccount {accountId: 'foo'}, (err, @result) =>
        should.exist err, "create account should return error"
        err.toString().should.eql 'Error: Invalid ObjectId'
        done()
