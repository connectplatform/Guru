should = require 'should'

boiler 'Policy - Middleware', ->
  it 'should block users from performing forbidden actions', (done) ->
    @client = @getClient()
    @client.ready =>
      @client.deleteModel {modelId: 'some_id', modelName: 'Website'}, (err) ->
        err.should.eql 'You must be logged in to access this feature.'
        done()
