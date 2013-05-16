should = require 'should'
db = config.require 'load/mongo'
{Session, ChatSession} = db.models

boiler 'Service - Logout', ->

  it 'should remove your session', (done) ->
    @ownerLogin (err, client, {sessionSecret, accountId}) =>
      should.not.exist err
      sessionId = client.localStorage.sessionId
      client.logout (err) =>
        Session.findById sessionId, (err, session) ->
          should.not.exist err
          should.not.exist session
          done()

  # it 'should remove your session', (done) ->
  #   @getAuthed =>
  #     sessionSecret = @sessionSecret
  #     operatorId = @ownerUser._id
  #     accountId = @account.id

  #     @client.logout (err) =>
  #       console.log {err}
        
  #       should.not.exist err, 'expected no errors from logout'
  #       done err

        # # session model should not be found
        # Session(accountId).get(sessionId).dump (err, data) =>
        #   should.exist err
        #   err.toString().should.eql 'Error: Session does not exist.'

        #   ChatSession(accountId).getBySession sessionId, (err, chatSessions) =>
        #     should.not.exist err
        #     should.exist chatSessions
        #     chatSessions.should.be.empty

        #     # keys should not exist
        #     redis.keys "*#{sessionId}*", (err, keys) ->
        #       should.not.exist err
        #       should.exist keys
        #       keys.should.be.empty

        #       # lookups should not exist
        #       redis.smembers "account:#{accountId}:session:allSessions", (err, keys) ->
        #         keys.should.not.include sessionId

        #         redis.smembers "account:#{accountId}:session:onlineOperators", (err, keys) ->
        #           keys.should.not.include sessionId

        #           redis.hget "account:#{accountId}:session:sessionsByOperator", operatorId, (err, lookup) ->
        #             should.not.exist err
        #             should.not.exist lookup, 'expected sessionsByOperator to be cleaned'
        #             done()
