should = require 'should'

boiler 'Service - Email Chat', ->
  it 'should send the transcript of a chat as an email', (done) ->
    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>

        pack = (message) =>
          {
            chatId: @chatId
            sessionId: @visitorSession
            message: message
          }

        client.say (pack 'Hello'), =>
          client.say (pack 'How are you?'), =>

            client.emailChat @chatId, 'success@simulator.amazonses.com', (err, exitStatus) =>
              should.not.exist err
              should.exist exitStatus
              exitStatus.message.should.match /MessageId/
              client.disconnect()
              done()
