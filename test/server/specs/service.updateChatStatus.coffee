should = require 'should'

boiler 'Service - Update Chat Status', ->
  beforeEach (done) ->
    stoic = require 'stoic'
    {Chat} = stoic.models
    @getAuthed (err, _, accountId) =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor) =>
        @chatHandle = Chat(accountId).get(@chatId)
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

