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

  #describe 'when Subscription Past Due', ->
    #it 'should not allow User creation', (done) ->
      #done()

  describe 'when Subscription Terminated', ->
    beforeEach (done) ->
      terminateSubscription = config.service 'recurly/terminateSubscription'

      # terminate simulates recurly's automated process after no payment
      @terminate = (next) =>
        terminateSubscription {accountId: @paidAccountId}, (err, result) ->
          should.not.exist err
          next()

      # create an operator and log in
      Factory.create 'website', {accountId: @paidAccountId, url: 'bazango.com'}, (err, website) =>
        should.not.exist err, "expected a new website: #{err}"
        @websiteId = website._id

        Factory.create 'operator', {accountId: @paidAccountId, websites: [website._id]}, (err, operator) =>
          should.not.exist err, "expected a new operator: #{err}"

          @getAuthedWith {email: operator.email, password: 'foobar'}, (err, @client) =>
            should.not.exist err

            done()

    it 'should not route chats', (done) ->
      getAvailableOperators = config.service 'operator/getAvailableOperators'

      @terminate =>
        getAvailableOperators {websiteId: @websiteId, specialty: 'Sales'}, (err, results) ->
          should.not.exist err
          {accountId, operators} = results
          should.exist accountId, 'expected accountId'
          should.exist operators, 'expected operator list'
          operators.length.should.eql 0, 'Expected operator list to be empty.'
          done()

    it 'should not allow accepting chats', (done) ->
      @timeout 4000

      @newChatWith {username: 'Frank', websiteUrl: 'bazango.com'}, (err) =>
        should.not.exist err, "expected create chat to succeed: #{err}"
        should.exist @chatId, 'expected chatId to exist'

        @terminate =>
          @client.acceptChat {chatId: @chatId}, (err, result) =>
            should.exist err, 'expected validation error'
            err.should.eql 'This feature is not available as your account is not in good standing.'
            done()
