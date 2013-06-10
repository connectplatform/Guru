should = require 'should'
async = require 'async'

boiler 'Service - Get Chat History', ->

  it 'should return the history of a chat', (done) ->
    @getAuthed (err) =>
      should.not.exist err
      
      username = 'historyVisitor'
      data = {username, websiteUrl: 'foo.com'}
      @newVisitor data, (err, @client, vars) =>
        {sessionId, chatId} = vars

        messages = ['first message', 'second message']
        say = (message, next) =>
          @client.say {sessionId, chatId, message}, next
        async.forEach messages, say, =>
          
          @client.getChatHistory {sessionId, chatId}, (err, data) =>
            should.not.exist err

            for entry, count in data
              entry.username.should.eql username
              entry.message.should.eql messages[count]

            done()
