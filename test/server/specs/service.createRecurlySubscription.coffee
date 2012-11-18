should = require 'should'
{inspect} = require 'util'

boiler 'Service - Create Recurly Subscription', ->
  before ->
    @createRecurlySubscription = config.service 'account/createRecurlySubscription'

  describe 'with valid data', ->
    it 'should create a subscription', (done) ->
      @createRecurlySubscription {accountId: @account._id}, (err, @result) =>
        console.log 'err:', err
        console.log 'result:', @result
        done()
