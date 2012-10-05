should = require 'should'

boiler 'Service - Print Chat', ->
  it 'should convert a chat to a printable html document', (done) ->
    @newVisitor {username: 'visitor'}, (err, client) =>

      pack = (message) =>
        {
          chatId: @chatId
          sessionId: @visitorSession
          message: message
        }

      client.say (pack 'Hello'), =>
        client.say (pack 'How are you?'), =>

          client.printChat @chatId, (err, html) =>
            should.not.exist err
            html.should.eql "<p>visitor: Hello</p><p>visitor: How are you?</p>"
            client.disconnect()
            done()
