should = require 'should'
relCache = config.require 'load/relationsCache'

describe 'Relations Cache', ->
  beforeEach ->
    relCache.clear()

  it 'with no data should return empty array', (done) ->
    rels = relCache.get 'sessionId', 123
    rels.should.exist
    rels.should.be.an.instanceof Array
    rels.should.be.empty
    done()

  it 'should store and retrieve relation', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    rels = relCache.get 'sessionId', 123

    rels.should.exist
    rels.should.eql [{accountId: 456}]
    done()

  it 'should store and retrieve duplicate keys', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.set 'sessionId', 123, {accountId: 789}

    rels = relCache.get 'sessionId', 123

    rels.should.exist
    rels.should.eql [{accountId: 456}, {accountId: 789}]
    done()

  it 'should import data', (done) ->
    relCache.import {
      sessionId:
        '123': [
          {accountId: 456}
        ]
    }

    rels = relCache.get 'sessionId', 123

    rels.should.exist
    rels.should.eql [{accountId: 456}]
    done()

  it 'should unset all relations', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.unset 'sessionId', 123
    rels = relCache.get 'sessionId', 123

    rels.should.exist
    rels.should.be.an.instanceof Array
    rels.should.be.empty
    done()

  it 'should unset target relation', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.set 'sessionId', 123, {accountId: 789}
    relCache.unset 'sessionId', 123, {accountId: 456}
    rels = relCache.get 'sessionId', 123

    rels.should.exist
    rels.should.eql [{accountId: 789}]
    done()

  it 'should find a key', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.set 'sessionId', 123, {accountId: 789}
    rel = relCache.findOne 'sessionId', 123, {accountId: 456}

    rel.should.exist
    rel.should.eql {accountId: 456}
    done()

  it 'should find an index', (done) ->
    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.set 'sessionId', 123, {accountId: 789}
    index = relCache.findIndex 'sessionId', 123, {accountId: 456}

    index.should.exist
    index.should.eql 0
    done()

  it 'should emit a set event', (done) ->
    relCache.once 'set', ({key, value, relation}) ->
      key.should.eql 'sessionId'
      value.should.eql 123
      relation.should.eql {accountId: 456}

      done()

    relCache.set 'sessionId', 123, {accountId: 456}

  it 'should emit an unset event', (done) ->
    relCache.once 'unset', ({key, value, relation}) ->
      key.should.eql 'sessionId'
      value.should.eql 123
      should.not.exist relation

      done()

    relCache.set 'sessionId', 123, {accountId: 456}
    relCache.unset 'sessionId', 123
