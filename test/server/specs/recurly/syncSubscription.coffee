should = require 'should'
{inspect} = require 'util'

verify = (operation, resource, err, result) ->
  should.not.exist err, "#{operation} #{resource} should not return error: #{err}\n
     status code: #{result?.status}\n#{inspect result?[resource], false, 10}"
  should.exist result[resource], "Expected #{resource} to exist."

boiler 'Recurly - Sync Subscription', ->
  beforeEach ->
    @createRecurlyAccount = config.service 'recurly/createAccount'
    @createRecurlyBilling = config.service 'recurly/createBilling'
    @syncSubscription = config.service 'recurly/syncSubscription'
    @accountId = @account._id.toString()

    @prep = (next) =>
      @createRecurlyAccount {accountId: @accountId}, (err, result) =>
        verify 'create', 'account', err, result

        billing =
          first_name: 'Bob'
          last_name: 'Smith'
          number: '4111111111111111'
          month: '07'
          year: '2014'

        @createRecurlyBilling {accountId: @accountId, billingInfo: billing}, (err, result) =>
          verify 'create', 'billing_info', err, result
          next()

  it 'should create my subscription', (done) ->
    @prep =>
      @syncSubscription {accountId: @accountId, seatCount: 1}, (err, result) ->
        should.not.exist err
        should.exist result?.seatCount, 'result should have seatCount'
        result.seatCount.should.eql 1
        done()

  it 'should modify my subscription', (done) ->
    @timeout 4000
    @prep =>
      @syncSubscription {accountId: @accountId, seatCount: 1}, (err, result) =>
        should.not.exist err
        should.exist result?.seatCount, 'result should have seatCount'
        result.seatCount.should.eql 1

        @syncSubscription {accountId: @accountId, seatCount: 3}, (err, result) ->
          should.not.exist err
          should.exist result?.seatCount, 'result should have seatCount'
          result.seatCount.should.eql 3
          done()

  it 'should remove my subscription', (done) ->
    @timeout 4000
    @prep =>
      @syncSubscription {accountId: @accountId, seatCount: 1}, (err, result) =>
        should.not.exist err
        should.exist result?.seatCount, 'result should have seatCount'
        result.seatCount.should.eql 1

        @syncSubscription {accountId: @accountId, seatCount: 0}, (err, result) ->
          should.not.exist err
          should.exist result?.seatCount, 'result should have seatCount'
          should.exist result?.status, 'result should have status'
          result.status.should.eql 'canceled'
          done()
