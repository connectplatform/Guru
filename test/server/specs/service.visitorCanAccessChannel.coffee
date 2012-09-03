should = require 'should'

boiler 'Service - Visitor Can Access Channel', ->
  beforeEach (done) ->
    @newChat =>
      # hijack the visitor's session
      @client = @getClient()
      session = @visitor.cookie('session')
      @client.cookie 'session', session
      @client.ready -> done()

  afterEach ->
    @client.disconnect()

  it 'should say a visitor can connect to a chat that they created', (done) ->
    @client.visitorCanAccessChannel @chatChannelName, (err, accessAllowed) =>
      should.not.exist err
      accessAllowed.should.eql true
      done()

  it 'should not let a visitor access a channel they were kicked from', (done) ->
    kickUser = config.require 'services/kickUser'
    mockRes = reply: =>
      #This will be executed after the kick
      @client.visitorCanAccessChannel @chatChannelName, (err, accessAllowed) =>
        should.not.exist err
        accessAllowed.should.eql false
        done()

    kickUser mockRes, @chatChannelName
