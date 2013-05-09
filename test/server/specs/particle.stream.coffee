should = require 'should'
db = config.require 'server/load/mongo'
{Account, User} = db.models
particle = require 'particle'

boiler 'particle', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      should.not.exist err
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.not.exist err
        @userId = user._id
        done err
    
  it 'should register a visitor session with a Stream', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session
      @sessionId = session._id
      collector = new particle.Collector
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionId: @sessionId
      should.exist collector

      collector.on 'data', (data, event) ->
        console.log {data, event}

      collector.register (err) ->
        should.not.exist err
        done()

  it 'should register a User session with a Stream', (done) ->
    Factory.create 'session', {@accountId, @userId}, (err, session) =>
      should.not.exist err
      should.exist session
      @sessionId = session._id
      collector = new particle.Collector
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionId: @sessionId
      should.exist collector

      collector.on 'data', (data, event) ->
        console.log {data, event}

      collector.register (err) ->
        should.not.exist err
        done()

  it 'should not register without an valid sessionId', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session
      @sessionId = session._id
      # We have a valid session, but we won't use it
      collector = new particle.Collector
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionId: @accountId # sic
      should.exist collector

      collector.on 'data', (data, event) ->
        console.log {data, event}

      collector.register (err) ->
        should.exist err
        console.log 'err', err
        done()