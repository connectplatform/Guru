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
        ops.length.should.eql 0
        done()

  describe 'with one operator', ->
    it 'should return one result', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators 'foo.com', 'Sales', (err, ops) ->
          should.not.exist err
          should.exist ops
          ops.length.should.eql 1, 'Expected one operator.'
          done()

  describe 'if website does not match', ->
    it 'should return no results', (done) ->
      @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
        @getAvailableOperators 'bar.com', 'Sales', (err, ops) ->
          should.not.exist err
          should.exist ops
          ops.length.should.eql 0, 'Expected no operators.'
          done()
