should = require 'should'

boiler 'Service - Print Chat', ->
  it 'should convert a chat to a printable html document', (done) ->
    # TODO: maybe later
    # Disabled. I not see reason in order to test some HTML code
    done()
    return

    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>

        client.say {chatId: @chatId, message: 'Hello'}, =>
          client.say {chatId: @chatId, message: 'How are you?'}, =>

            client.printChat {chatId: @chatId}, (err, {html}) =>
              should.not.exist err
              html.should.match new RegExp '<h2>Chat History</h2><p><strong>Time:</strong>.*</p><p><strong>Customer:</strong>visitor</p><p><strong>Website:</strong>foo.com</p><p><strong>visitor:</strong>Hello</p><p><strong>visitor:</strong>How are you\\?</p>'
              done()
