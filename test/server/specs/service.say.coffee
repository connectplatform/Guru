should = require 'should'

boiler 'Service - Say', ->

  it 'should let you say a message in a chat', (done) ->
    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor) =>
        console.log {@chatId}
        message = 'Hello, world!'
        @visitor.say {@chatId, message}, (err, {status}) =>
          should.not.exist err
          should.exist status, 'expected status'
          status.should.eql 'OK'

          @visitor.getChatHistory {chatId: @chatId}, (err, {history}) =>
            should.not.exist err
            should.exist history
            history.length.should.eql 1

            [{username, message, timestamp}] = history
            username.should.eql 'visitor'
            message.should.eql 'Hello, world!'
            timestamp.should.exist
            done()
