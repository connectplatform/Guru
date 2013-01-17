should = require 'should'

boiler 'Service - Logout', ->

  it 'should log you out', (done) ->
    @getAuthed =>
      @client.logout (err) =>
        should.not.exist err
        should.not.exist @client.cookie('session'), 'expected session cookie to be removed'
        done()

  it 'should remove your session', (done) ->
    stoic = require('stoic')
    {Session, ChatSession} = stoic.models
    redis = stoic.client

    @getAuthed =>
      sessionId = @client.cookie 'session'
      operatorId = @ownerUser._id
      accountId = @account.id

      @client.logout (err) =>

        # session model should not be found
        Session(accountId).get(sessionId).dump (err, data) =>
          should.exist err
          err.toString().should.eql 'Error: Session does not exist.'

          ChatSession(accountId).getBySession sessionId, (err, chatSessions) =>
            should.not.exist err
            should.exist chatSessions
            chatSessions.should.be.empty

            # keys should not exist
            redis.keys "*#{sessionId}*", (err, keys) ->
              should.not.exist err
              should.exist keys
              keys.should.be.empty

              # lookups should not exist
              redis.smembers "account:#{accountId}:session:allSessions", (err, keys) ->
                keys.should.not.include sessionId

                redis.smembers "account:#{accountId}:session:onlineOperators", (err, keys) ->
                  keys.should.not.include sessionId

                  redis.hget "account:#{accountId}:session:sessionsByOperator", operatorId, (err, lookup) ->
                    should.not.exist err
                    should.not.exist lookup, 'expected sessionsByOperator to be cleaned'
                    done()
