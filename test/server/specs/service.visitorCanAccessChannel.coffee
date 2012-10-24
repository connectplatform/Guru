should = require 'should'

boiler 'Service - Visitor Can Access Channel', ->
  beforeEach (done) ->
    @adminLogin (err, @admin) =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @client) =>
        @admin.joinChat @chatId, done

  afterEach ->
    @client.disconnect()

  it 'should say a visitor can connect to a chat that they created', (done) ->
    @client.visitorCanAccessChannel @chatId, (err, accessAllowed) =>
      should.not.exist err
      accessAllowed.should.eql true
      done()

  it 'should not let a visitor access a channel they were kicked from', (done) ->
    @admin.kickUser @chatId, (err) =>
      @client.visitorCanAccessChannel @chatId, (err, accessAllowed) =>
        should.not.exist err
        accessAllowed.should.eql false
        @admin.disconnect()
        done()
