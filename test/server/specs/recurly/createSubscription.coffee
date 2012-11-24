should = require 'should'
{inspect} = require 'util'

verify = (operation, resource, err, result) ->
  should.not.exist err, "#{operation} #{resource} should not return error: #{err}\n
     status code: #{result?.status}\n#{inspect result?[resource], false, 10}"
  should.exist result[resource], "Expected #{resource} to exist."

boiler 'Recurly - Subscription', ->
  beforeEach (done) ->
    @createRecurlyAccount = config.service 'recurly/createAccount'
    @createRecurlySubscription = config.service 'recurly/createSubscription'
    @createRecurlyBilling = config.service 'recurly/createBilling'
    @getRecurlyAccount = config.service 'recurly/getAccount'
    @accountId = @account._id.toString()

    @getRecurlySubscription = config.service 'recurly/getSubscription'
    @editRecurlySubscription = config.service 'recurly/editSubscription'
    @cancelRecurlySubscription = config.service 'recurly/cancelSubscription'
    @reactivateRecurlySubscription = config.service 'recurly/reactivateSubscription'

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
        done()

  describe 'Create', ->
    it 'should return success', (done) ->
      @createRecurlySubscription {accountId: @accountId, quantity: 1}, (err, result) =>
        verify 'create', 'subscription', err, result
        done()

  describe 'With existing subscription', ->
    beforeEach (done) ->
      @createRecurlySubscription {accountId: @accountId, quantity: 1}, (err, result) =>
        verify 'create', 'subscription', err, result
        done()

    it 'Get should return success', (done) ->
      @getRecurlySubscription {accountId: @accountId}, (err, result) =>
        verify 'edit', 'subscription', err, result
        done()

    it 'Edit should return success', (done) ->
      @editRecurlySubscription {accountId: @accountId, quantity: 3}, (err, result) =>
        verify 'edit', 'subscription', err, result
        done()

    it 'Cancel should return success', (done) ->
      @cancelRecurlySubscription {accountId: @accountId}, (err, result) =>
        verify 'cancel', 'subscription', err, result
        done()

    it 'Reactivate should return success', (done) ->
      @cancelRecurlySubscription {accountId: @accountId}, (err, result) =>
        verify 'cancel', 'subscription', err, result
        @reactivateRecurlySubscription {accountId: @accountId}, (err, result) =>
          verify 'reactivate', 'subscription', err, result
          done()
