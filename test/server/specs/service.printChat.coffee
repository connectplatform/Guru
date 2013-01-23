should = require 'should'

boiler 'Service - Print Chat', ->
  it 'should convert a chat to a printable html document', (done) ->
    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>

        client.say {chatId: @chatId, message: 'Hello'}, =>
          client.say {chatId: @chatId, message: 'How are you?'}, =>

            client.printChat {chatId: @chatId}, (err, {html}) =>
              should.not.exist err
              html.should.eql "<p>visitor: Hello</p><p>visitor: How are you?</p>"
              client.disconnect()
              done()
