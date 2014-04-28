should = require 'should'
stoic = require 'stoic'

boiler 'Service - Update Chat Status', ->
  beforeEach (done) ->
    {Chat} = stoic.models
    @getAuthed (err, _, {@accountId}) =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor) =>
        @chatHandle = Chat(@accountId).get(@chatId)
        done()

  it "should set a chat's status to 'waiting' when there is a visitor and no operator", (done) ->
    @chatHandle.status.get (err, status) =>
      should.not.exist err
      status.should.eql 'waiting'
      done()

  it "should set a chat's status to 'active' when there's an operator and a visitor", (done) ->
    @guru1Login (err, client) =>
      client.acceptChat {chatId: @chatId}, (err, data) =>
        @chatHandle.status.get (err, status) =>
          should.not.exist err
          status.should.eql 'active'
          done()

  it "should set a chat's status to 'vacant' when there's no visitor", (done) ->
    @visitor.leaveChat {chatId: @chatId}, (err) =>
      should.not.exist err
      @chatHandle.status.get (err, status) =>
        should.not.exist err
        status.should.eql 'vacant'
        done()

  it "should remove notifications when chat leaves waiting status", (done) ->
    {Session} = stoic.models
    @visitor.leaveChat {chatId: @chatId}, (err) =>
      should.not.exist err
      Session(@accountId).get(@sessionId).unansweredChats.all (err, unanswered) ->
        should.not.exist err
        unanswered.length.should.eql 0

        done()
