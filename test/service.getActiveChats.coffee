require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Active Chats', ->

  it 'should return data on all existing chats', (done) ->
    data = {username: 'foo'}
    @client.newChat data, =>

      loginData =
        email: 'god@torchlightsoftware.com'
        password: 'foobar'

      client2 = @getClient()
      client2.ready ->
        client2.login loginData, ->

          client2.getActiveChats (err, chats) ->
            client2.disconnect()
            false.should.eql err?
            [chatData] = chats
            chatData.visitor.username.should.eql 'foo'
            chatData.visitorPresent.should.eql 'true' #TODO this is a hack
            new Date chatData.creationDate #just need this to not cause an error
            done()
