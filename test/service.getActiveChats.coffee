require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get Active Chats', ->

  it 'should return data on all existing chats', (done) ->
    data = {username: 'foo'}
    client1 = @getClient()
    client1.ready =>
      client1.newChat data, =>
        client1.disconnect()

        @getAuthed =>
          @client.getActiveChats (err, chats) ->
            false.should.eql err?
            [chatData] = chats
            chatData.visitor.username.should.eql 'foo'
            chatData.visitorPresent.should.eql 'true' #TODO this is a hack until boolean redgoose types are added
            new Date chatData.creationDate #just need this to not cause an error
            done()