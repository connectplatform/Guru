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
    @accountInGoodStanding = config.service 'recurly/accountInGoodStanding'
    @terminateSubscription = config.service 'recurly/terminateSubscription'
    @cancelSubscription = config.service 'recurly/cancelSubscription'

    @accountId = @account._id.toString()

    @createBilling = ({accountId, billingData}, next) =>
      billing =
        first_name: 'Bob'
        last_name: 'Smith'
        number: '4111111111111111'
        month: '07'
        year: '2014'

      billing.merge billingData if billingData

      @createRecurlyBilling {accountId: accountId, billingInfo: billing}, (err, result) =>
        #verify 'create', 'billing_info', err, result
        next()

  describe 'with unlimited account', ->
    it 'should return true', (done) ->
      @accountInGoodStanding {accountId: @accountId}, (err, {goodStanding}) ->
        should.not.exist err
        should.exist goodStanding
        goodStanding.should.eql true
        done()

  describe 'with paid account', ->
    beforeEach (done) ->
      @createRecurlyAccount {accountId: @paidAccountId}, done

    it 'and one user should return true', (done) ->
      @accountInGoodStanding {accountId: @paidAccountId}, (err, {goodStanding}) ->
        should.not.exist err
        should.exist goodStanding
        goodStanding.should.eql true
        done()

    it 'and two users with active subscription should return true', (done) ->
      @createBilling {accountId: @paidAccountId}, (err) =>
        should.not.exist err

        Factory.create 'operator', {accountId: @paidAccountId}, (err, op) =>
          should.not.exist err
          should.exist op

          @accountInGoodStanding {accountId: @paidAccountId}, (err, {goodStanding}) ->
            should.not.exist err
            should.exist goodStanding
            goodStanding.should.eql true
            done()

    it 'and two users with canceled subscription should return true', (done) ->
      @createBilling {accountId: @paidAccountId}, (err) =>
        should.not.exist err

        Factory.create 'operator', {accountId: @paidAccountId}, (err, op) =>
          should.not.exist err
          should.exist op

          @cancelSubscription {accountId: @paidAccountId}, (err) =>

            @accountInGoodStanding {accountId: @paidAccountId}, (err, {goodStanding}) ->
              should.not.exist err
              should.exist goodStanding
              goodStanding.should.eql true
              done()

    it 'and two users with expired subscription should return false', (done) ->
      @createBilling {accountId: @paidAccountId}, (err) =>
        should.not.exist err

        Factory.create 'operator', {accountId: @paidAccountId}, (err, op) =>
          should.not.exist err
          should.exist op

          @terminateSubscription {accountId: @paidAccountId}, (err) =>

            @accountInGoodStanding {accountId: @paidAccountId}, (err, {goodStanding}) ->
              should.not.exist err
              should.exist goodStanding
              goodStanding.should.eql false
              done()
