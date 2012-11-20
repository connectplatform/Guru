should = require 'should'
{inspect} = require 'util'

boiler 'Service - Create Recurly Subscription', ->
  beforeEach (done) ->
    @createRecurlyAccount = config.service 'account/createRecurlyAccount'
    @createRecurlySubscription = config.service 'account/createRecurlySubscription'
    @createRecurlyBilling = config.service 'account/createRecurlyBilling'
    @getRecurlyAccount = config.service 'account/getRecurlyAccount'
    @accountId = @account._id.toString()

    @createRecurlyAccount {accountId: @accountId}, (err, result) =>
      should.not.exist err, "create account should not return error: #{err}\n#{inspect result.account, false, 10}"
      should.exist result.account

      billing =
        first_name: 'Bob'
        last_name: 'Smith'
        number: '4111111111111111'
        month: '07'
        year: '2014'

      @createRecurlyBilling {accountId: @accountId, billingInfo: billing}, (err, result) =>
        should.not.exist err, "create billing should not return error: #{err}\nstatus code:#{result.status}\n#{inspect result?.billing_info, false, 10}"
        should.exist result.billing_info

        done()

  describe 'with valid data', ->
    it 'should create a subscription', (done) ->
      @createRecurlySubscription {accountId: @accountId, quantity: 1}, (err, @result) =>

        should.not.exist err, "create subscription should not return error: #{err}\nstatus code:#{result.status}\n#{inspect result?.subscription, false, 10}"
        should.exist result.subscription
        done()
