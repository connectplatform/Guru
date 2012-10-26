should = require 'should'

boiler 'Service - New Chat', ->

  it 'should let you chat', (done) ->
    @getAuthed =>
      client = @getClient()
      client.ready =>
        client.newChat {username: 'visitor', websiteUrl: 'foo.com'}, (err, response) =>
          should.not.exist err
          chatId = response.chatId

          # establish listener
          @channel = @getPulsar().channel chatId
          @channel.on 'serverMessage', (data) ->
            data.message.should.eql 'hello!'
            done()

          client.say {message: 'hello!', chatId: chatId}, (err) =>
            should.not.exist err
            client.disconnect()

  it 'should notify operators of a new chat', (done) ->
    @getAuthed =>
      session = @client.cookie 'session'
      notify = @getPulsar().channel "notify:session:#{session}"
      notify.on 'unansweredChats', ({count}) =>
        count.should.eql 1
        notify.removeAllListeners 'unansweredChats'
        @client.disconnect()
        done()

      @newChat ->

  it 'should return {noOperators: true} if no operators are available', (done) ->
    @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
      @newChatWith {username: 'visitor', websiteUrl: 'bar.com'}, (err, {data}) ->
        should.not.exist err
        should.exist data
        data.should.eql {noOperators: true}
        done()
