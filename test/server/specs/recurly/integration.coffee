should = require 'should'
{inspect} = require 'util'

verify = (operation, resource, err, result) ->
  should.not.exist err, "#{operation} #{resource} should not return error: #{err}\n
     status code: #{result?.status}\n#{inspect result?[resource], false, 10}"
  should.exist result[resource], "Expected #{resource} to exist."

boiler 'Recurly - Integration', ->
  beforeEach (done) ->
    @createRecurlyAccount = config.service 'recurly/createAccount'
    @createRecurlyBilling = config.service 'recurly/createBilling'
    @getRecurlySubscription = config.service 'recurly/getSubscription'

    @createRecurlyAccount {accountId: @paidAccountId}, (err, result) =>
      verify 'create', 'account', err, result

      billing =
        first_name: 'Bob'
        last_name: 'Smith'
        number: '4111111111111111'
        month: '07'
        year: '2014'

      @createRecurlyBilling {accountId: @paidAccountId, billingInfo: billing}, (err, result) =>
        verify 'create', 'billing_info', err, result
        done()

  describe 'User Sync', ->
    it 'Creating a user should create a subscription', (done) ->
      @timeout 4000

      # create a new operator
      Factory.create 'operator', {accountId: @paidAccountId}, (err, operator) =>
        should.not.exist err, "create operator should succeed: #{err}"

        # subscription should be up to date
        @getRecurlySubscription {accountId: @paidAccountId}, (err, data) ->
          should.not.exist err, "get subscription should succeed: #{err}"
          quantity = data?.subscription?.quantity?.value
          should.exist quantity, 'expected subscription quantity'
          quantity.should.eql '1'
          done()

    it 'Deleting the only user should cancel the subscription', (done) ->
      @timeout 4000

      # create a new operator
      Factory.create 'operator', {accountId: @paidAccountId}, (err, operator) =>
        operator.remove =>

          # subscription should be up to date
          @getRecurlySubscription {accountId: @paidAccountId}, (err, data) ->
            should.not.exist err, "get subscription should succeed: #{err}"
            state = data?.subscription?.state
            should.exist state, 'expected subscription state'
            state.should.eql 'canceled'
            done()

  #describe 'Chat Validation', ->
    #it 'should not allow chat routing when account lapsed', (done) ->
      #done()
