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

    @getAuthed =>
      sess = Session.get @client.cookie 'session'
      Session.onlineSessions.all (err, sessions) ->
        sessions.map((s) -> s.id).should.include sess.id

        sess.online.set 'false', (err, status) ->
          Session.onlineSessions.all (err, sessions) ->
            sessions.map((s) -> s.id).should.not.include sess.id

            sess.online.set 'true', (err, status) ->
              Session.onlineSessions.all (err, sessions) ->
                sessions.map((s) -> s.id).should.include sess.id
                done()
