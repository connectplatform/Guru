should = require 'should'

boiler 'Service - Email Chat', ->
  it 'should send the transcript of a chat as an email', (done) ->
    @getAuthed (err, @client) =>
      should.not.exist err
      should.exist @client
      
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>
        @client.joinChat {@chatId}, (err) =>
          should.not.exist err

          pack = (message) =>
            chatId: @chatId
            message: message

          @client.say pack('Hello'), =>
            @client.say pack('How are you?'), =>
              @client.emailChat {@chatId, email: 'success@simulator.amazonses.com'}, (err, response) =>
                should.not.exist err
                should.exist response
                response.message.should.match /MessageId/
                done()
