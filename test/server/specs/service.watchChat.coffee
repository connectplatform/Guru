should = require 'should'
stoic = require 'stoic'

boiler 'Service - Watch Chat', ->

  #TODO add test that shows that this operator can't post in pulsarChannel
  it 'should let an operator view a chat', (done) ->

    # given
    @getAuthed =>
      visitorClient = @getClient()
      visitorClient.ready =>
        visitorClient.newChat {username: 'foo', websiteUrl: 'foo.com'}, (err, {chatId}) =>
          should.not.exist err

          visitorClient.ready =>
            visitorClient.disconnect()
            clientMessage = "hello, world!"

            visitorClient.say {message: clientMessage, chatId: chatId}, =>

              # when
              @client.watchChat {chatId: chatId}, (err, data) =>

                # expect
                should.not.exist err
                @client.getChatHistory {chatId: chatId}, (err, {username, message}) =>
                  should.not.exist err

                  username.should.eql 'foo'
                  message.should.eql message
                  done()
