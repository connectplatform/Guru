should = require 'should'

boiler 'Service - Get Chat History', ->

  it 'should return the history of a chat', (done) ->
    @getAuthed =>
      @client = @getClient()
      @client.ready =>
        username = 'historyVisitor'
        data = {username: username, websiteUrl: 'foo.com'}
        @client.newChat data, (err, {chatId}) =>
          sessionId = @client.cookie 'session'

          messages = ['first message', 'second message']
          @client.say {chatId: chatId, message: messages[0]}, =>
            @client.say {chatId: chatId, message: messages[1]}, =>

              @client.getChatHistory chatId, (err, data) =>
                @client.disconnect()
                false.should.eql err?

                testEntry = (entry, count) ->
                  entry.username.should.eql username
                  entry.should.eql messages[count]

                testEntry for entry, count in data
                done()
