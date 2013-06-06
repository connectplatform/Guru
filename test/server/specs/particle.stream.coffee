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
        should.exist user
        @userId = user._id
        done err
    
  it 'should register a visitor session with a Stream', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session

      collector = new particle.Collector
        # onDebug: console.log
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionSecret: session.secret
      should.exist collector

      collector.on 'data', (data, event) ->
        # console.log {data, event}

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
          sessionSecret: session.secret
      should.exist collector

      collector.on 'data', (data, event) ->
        # console.log {data, event}

      collector.register (err) ->
        should.not.exist err
        done()

  it 'should not register without a valid sessionSecret', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session
      
      # We have a valid session, but we won't use it
      collector = new particle.Collector
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionSecret: @accountId # sic
      should.exist collector

      collector.on 'data', (data, event) ->
        # console.log {data, event}

      collector.register (err) ->
        should.exist err
        errMsg = 'No Session associated with sessionSecret'
        err.should.equal errMsg
        done()

  it 'should update upon a change in username', (done) ->
    Factory.create 'session', {@accountId, @userId}, (err, session) =>
      should.not.exist err
      should.exist session
      oldUsername = session.username
      newUsername = oldUsername + ' (Updated)'
      
      collector = new particle.Collector
        # onDebug: console.log
        network:
          host: 'localhost'
          port: process.env.GURU_PORT
        identity:
          sessionSecret: session.secret
      should.exist collector

      collector.on 'sessions.*', (data, event) ->
        verify = () ->
          event.path.should.equal 'username'
          event.data.should.equal newUsername
          done()
        verify()
      
      collector.register (err, next) ->
        should.not.exist err
        session.username = newUsername
        session.save next
