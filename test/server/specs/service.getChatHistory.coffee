should = require 'should'
async = require 'async'

boiler 'Service - Get Chat History', ->

  it 'should return the history of a chat', (done) ->
    @guru1Login (err, @guru1) =>
      should.not.exist err
      should.exist @guru1

      username = 'historyVisitor'
      data = {username, websiteUrl: 'foo.com'}
      @newVisitor data, (err, @client, vars) =>
        {sessionId, chatId} = vars

        messages = ['first message', 'second message']
        say = (message, next) =>
          @client.say {chatId, message}, next
        async.forEach messages, say, (err) =>
          should.not.exist err

          @client.getChatHistory {chatId}, (err, data) =>
            should.not.exist err

            for entry, count in data
              entry.username.should.eql username
              entry.message.should.eql messages[count]

            done()
