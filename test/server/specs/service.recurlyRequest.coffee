should = require 'should'
{inspect} = require 'util'

boiler 'Service - Recurly Request', ->
  before ->
    @recurlyRequest = config.service 'account/recurlyRequest'

  it 'should perform a GET request', (done) ->
    params =
      method: 'get'
      resource: 'accounts'

    @recurlyRequest params, (err, @result) =>
      should.not.exist err, "create account should not return error: #{err}\n#{inspect @result, false, 10}"
      @result.status.should.eql 200
      should.exist @result.accounts
      done()
