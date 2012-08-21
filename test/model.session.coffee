should = require 'should'
stoic = require 'stoic'
boiler = require './util/boilerplate'

boiler 'Model - Session ', ->

  it 'should reattatch a user to their session if they log out and back in', (done)->
    @getAuthed =>
      firstSessionId = @client.cookie 'session'
      @client.cookie 'session', null
      @getAuthed =>
        secondSessionId = @client.cookie 'session'
        firstSessionId.should.eql secondSessionId
        done()
