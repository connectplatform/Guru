{tandoor} = config.require 'lib/util'

example = tandoor (a, b, next) ->
  next a, b

longExample = tandoor (args..., next) ->
  next null, args

describe 'Util', ->
  describe 'Tandoor', ->

    it 'with callback, should execute immediately', (done) ->
      example 1, 2, (a, b) ->
        a.should.eql 1
        b.should.eql 2
        done()

    it 'with partial args, should delay execution', (done) ->
      partial = example 1, 2
      partial (a, b) ->
        a.should.eql 1
        b.should.eql 2
        done()

    it 'with long example, should be really fast', (done) ->
      partial = longExample
      for x in [1..100]
        partial = partial x
      partial done
