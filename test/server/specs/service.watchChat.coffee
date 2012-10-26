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
            clientMessage = "hello, world!"

            visitorClient.say {message: clientMessage, chatId: chatId}, =>
              visitorClient.disconnect()

              # when
              @client.watchChat {chatId: chatId}, (err, data) =>

                # expect
                should.not.exist err
                @client.getChatHistory {chatId: chatId}, (err, [entry]) =>
                  should.not.exist err

                  entry.username.should.eql 'foo'
                  entry.message.should.eql clientMessage
                  done()
