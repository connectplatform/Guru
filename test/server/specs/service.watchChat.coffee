should = require 'should'
stoic = require 'stoic'

boiler 'Service - Watch Chat', ->

  #TODO add test that shows that this operator can't post in pulsarChannel
  it 'should let an operator view a chat', (done) ->

    # given
    @getAuthed =>
      @newVisitor {username: 'foo', websiteUrl: 'foo.com'}, (err, visitorClient, {chatId}) =>
        clientMessage = "hello, world!"

        visitorClient.say {message: clientMessage, chatId: chatId}, =>
          visitorClient.disconnect()

          # when
          @client.watchChat {chatId: chatId}, (err, data) =>

            # expect
            should.not.exist err
            @client.getChatHistory {chatId: chatId}, (err, {history}) =>
              should.not.exist err

              [entry] = history
              should.exist entry.username
              entry.username.should.eql 'foo'
              entry.message.should.eql clientMessage
              done()
