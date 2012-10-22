should = require 'should'
stoic = require 'stoic'

boiler 'Model - Session', ->

  # this is really a service test
  it 'should reattatch a user to their session if they log out and back in', (done) ->
    @getAuthed =>
      firstSessionId = @client.cookie 'session'
      @client.cookie 'session', null
      @getAuthed =>
        secondSessionId = @client.cookie 'session'
        firstSessionId.should.eql secondSessionId
        done()

  it 'should keep onlineSessions synced with online flag', (done) ->
    {Session} = stoic.models

    @getAuthed (_..., accountId) =>
      sess = Session(accountId).get @client.cookie 'session'
      Session(accountId).onlineOperators.all (err, sessions) ->
        sessions.map((s) -> s.id).should.include sess.id, "Operator wasn't set as online at initial login"

        sess.online.set false, (err, status) ->
          Session(accountId).onlineOperators.all (err, sessions) ->
            sessions.map((s) -> s.id).should.not.include sess.id, "Operator wasn't set as offline"

            sess.online.set true, (err, status) ->
              Session(accountId).onlineOperators.all (err, sessions) ->
                sessions.map((s) -> s.id).should.include sess.id, "Operator wasn't re-set as online"
                done()
