should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Available Operators', ->
  beforeEach (done) ->
    @getAvailableOperators = config.require 'services/operator/getAvailableOperators'
    done()

  describe 'with no operators', ->
    it 'should return no results', (done) ->
      @getAvailableOperators 'foo.com', 'sales', (err, ops) ->
        should.not.exist err
        should.exist ops
        console.log ops
