should = require 'should'

boiler 'Service - Print Chat', ->
  it 'should convert a chat to a printable html document', (done) ->
    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>

        client.say {chatId: @chatId, message: 'Hello'}, =>
          client.say {chatId: @chatId, message: 'How are you?'}, =>

            client.printChat {chatId: @chatId}, (err, {html}) =>
              should.not.exist err
              should.exist html
              regex = new RegExp '<h2>Chat History</h2><p><strong>Time:</strong>.*</p><p><strong>Customer:</strong>visitor</p><p><strong>Website:</strong>foo.com</p><h3>Chats</h3><div class="well printPage"><p><strong>visitor:</strong>Hello</p><p><strong>visitor:</strong>How are you\\?</p></div>'
              html.should.match regex
              done()
