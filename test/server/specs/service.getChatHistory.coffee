should = require 'should'
async = require 'async'

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
          say = (message, next) => @client.say {chatId: chatId, message: message}, next
          async.forEach messages, say, =>

            @client.getChatHistory {chatId: chatId}, (err, data) =>
              @client.disconnect()
              should.not.exist err

              for entry, count in data
                entry.username.should.eql username
                entry.message.should.eql messages[count]

              done()
