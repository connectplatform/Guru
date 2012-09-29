should = require 'should'

boiler 'Service - Chat To HTML', ->
  it 'should convert a chat to an html document', (done) ->
    chatToHtml = config.require 'services/chats/chatToHtml'
    @newVisitor {username: 'visitor'}, (err, client) =>

      pack = (message) =>
        {
          chatId: @chatId
          sessionId: @visitorSession
          message: message
        }

      client.say (pack 'Hello'), =>
        client.say (pack 'How are you?'), =>

          chatToHtml @chatId, (err, html) =>
            should.not.exist err
            html.should.eql "<p>visitor: Hello</p><p>visitor: How are you?</p>"
            client.disconnect()
            done()
