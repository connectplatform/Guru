should = require 'should'
stoic = require 'stoic'

boiler 'Model - Session', ->

  # this is really a service test
  it 'should reattatch a user to their session if they log out and back in', (done) ->
    @getAuthed (err, client, {sessionId}) =>
      firstSessionId = sessionId
      @client.cookie 'session', null
      @getAuthed (err, client, {sessionId}) =>
        secondSessionId = sessionId
        firstSessionId.should.eql secondSessionId
        done()

  it 'should keep onlineOperators synced with online flag', (done) ->
    {Session} = stoic.models

    @getAuthed (_..., {accountId, sessionId}) =>
      sess = Session(accountId).get sessionId
      Session(accountId).onlineOperators.all (err, sessions) ->
        sessions.map((s) -> s.id).should.include sess.id, "Operator wasn't set as online at initial login"

        sess.online.set false, (err, status) ->
          Session(accountId).onlineOperators.all (err, sessions) ->
            sessions.map((s) -> s.id).should.not.include sess.id, "Operator wasn't set as offline"

            sess.online.set true, (err, status) ->
              Session(accountId).onlineOperators.all (err, sessions) ->
                sessions.map((s) -> s.id).should.include sess.id, "Operator wasn't re-set as online"
                done()
