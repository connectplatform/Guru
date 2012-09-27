should = require 'should'

boiler 'Service - Say', ->

  it 'should let you say a message in a chat', (done) ->
    @newVisitor {username: 'visitor'}, (err, @visitor) =>
      @visitor.say {chatId: @chatId, sessionId: @visitorSession, message: 'Hello, world!'}, (err, success) =>
        should.not.exist err
        success.should.eql 'OK'

        @visitor.getChatHistory @chatId, (err, [{username, message, timestamp}]) =>
          should.not.exist err
          username.should.eql 'visitor'
          message.should.eql 'Hello, world!'
          timestamp.should.exist
          done()
