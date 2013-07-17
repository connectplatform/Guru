{tandoor, hasKeys, getType, includes} = config.require 'lib/util'
{ObjectId} = require('mongoose').Schema.Types

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

  describe 'hasKeys', ->

    it 'empty keys should give true', ->
      result = hasKeys {a: 1, b: 2}, []
      result.should.eql true

    it 'present keys should give true', ->
      result = hasKeys {a: 1, b: 2}, ['a', 'b']
      result.should.eql true

    it 'non-present keys should give false', ->
      result = hasKeys {a: 1}, ['a', 'b']
      result.should.eql false

    it 'undefined obj should give false', ->
      result = hasKeys undefined, []
      result.should.eql false

  describe 'getType', ->

    tests = [
        description: 'empty object'
        input: {}
        expected: 'Object'
      ,
        description: 'empty array'
        input: []
        expected: 'Array'
      ,
        description: 'error'
        input: new Error
        expected: 'Error'
      ,
        description: 'string'
        input: 'hi'
        expected: 'String'
      ,
        description: 'undefined'
        input: undefined
        expected: 'Undefined'
      ,
        description: 'null'
        input: null
        expected: 'Null'
      ,
        description: 'ObjectId'
        input: new ObjectId()
        expected: 'ObjectId'
    ]

    for test in tests
      do (test) ->
        {description, input, expected} = test
        it description, ->
          result = getType input
          result.should.eql expected

  describe 'includes', ->

    tests = [
        description: 'empty object'
        set: {}
        subset: {}
        expected: true
      ,
        description: 'superset'
        set: {}
        subset: {a: 1}
        expected: false
      ,
        description: 'exact match'
        set: {a: 1}
        subset: {a: 1}
        expected: true
      ,
        description: 'wrong value'
        set: {a: 1}
        subset: {a: 2}
        expected: false
      ,
        description: 'subset'
        set: {a: 1, b: 2}
        subset: {a: 1}
        expected: true
    ]

    for test in tests
      do (test) ->
        {description, set, subset, expected} = test
        it description, ->
          result = includes set, subset
          result.should.eql expected
