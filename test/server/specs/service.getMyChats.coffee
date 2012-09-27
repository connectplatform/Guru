should = require 'should'

boiler 'Service - Get My Chats', ->
  it "should return data on all of a particular operator's chats", (done) ->
    client = @getClient()
    client.ready =>
      data = {username: 'joinMe'}
      client.newChat data, (err, {chatId}) =>
        client.cookie 'session', null
        client.disconnect()

        client2 = @getClient()
        client2.ready =>
          data = {username: 'butNotMe'}
          client2.newChat data, (err, data) =>
            client2.disconnect()

            @getAuthed =>
              @client.joinChat chatId, (err, data) =>

                @client.getMyChats (err, data) =>
                  should.not.exist err
                  data.length.should.eql 1
                  chatData = data[0]
                  chatData.visitor.username.should.eql 'joinMe'
                  chatData.status.should.eql 'waiting'
                  new Date chatData.creationDate #just need this to not cause an error
                  done()
