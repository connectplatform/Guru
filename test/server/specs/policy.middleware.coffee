should = require 'should'

boiler 'Policy - Middleware', ->
  it 'should block users from performing forbidden actions', (done) ->
    @guru1Login (err, @guru1) =>
      should.not.exist err
      should.exist @guru1
      
      @guru1.deleteModel {modelId: 'some_id', modelName: 'Website'}, (err) ->
        console.log {err}
        err.should.equal 'You must be an account Owner to access this feature.'
        done()
