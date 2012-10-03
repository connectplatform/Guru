should = require 'should'

boiler 'Service - Email Chat', ->
  it 'should send the transcript of a chat as an email', (done) ->
    @newVisitor {username: 'visitor'}, (err, client) =>

      pack = (message) =>
        {
          chatId: @chatId
          sessionId: @visitorSession
          message: message
        }

      client.say (pack 'Hello'), =>
        client.say (pack 'How are you?'), =>

          client.emailChat @chatId, 'test@torchlightsoftware.com', (err, exitStatus) =>
            should.not.exist err
            should.exist status
            status.message.should.eql 'Sendmail exited with 0'
            client.disconnect()
            done()
