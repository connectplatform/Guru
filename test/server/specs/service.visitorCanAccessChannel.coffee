should = require 'should'

boiler 'Service - Visitor Can Access Channel', ->
  beforeEach (done) ->
    @ownerLogin (err, @owner) =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @client) =>
        @owner.joinChat {chatId: @chatId}, done

  afterEach ->
    @client.disconnect()

  it 'should say a visitor can connect to a chat that they created', (done) ->
    @client.visitorCanAccessChannel {chatId: @chatId}, (err, accessAllowed) =>
      should.not.exist err
      accessAllowed.should.eql true
      done()

  it 'should not let a visitor access a channel they were kicked from', (done) ->
    @owner.kickUser {chatId: @chatId}, (err) =>
      @client.visitorCanAccessChannel {chatId: @chatId}, (err, accessAllowed) =>
        should.not.exist err
        accessAllowed.should.eql false
        @owner.disconnect()
        done()
