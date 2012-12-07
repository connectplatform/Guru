should = require 'should'

boiler 'Service - Get My Chats', ->
  it "should return data on all of a particular operator's chats", (done) ->
    @getAuthed =>
      client = @getClient()
      client.ready =>

        # Make a chat to join
        client.newChat {username: 'joinMe', websiteUrl: 'foo.com', arbitrary: 'someValue'}, (err, {chatId}) =>
          should.not.exist err
          client.cookie 'session', null
          client.disconnect()

          # Make a chat that we're not joining
          client2 = @getClient()
          client2.ready =>
            client2.newChat {username: 'butNotMe', websiteUrl: 'foo.com'}, (err, data) =>
              should.not.exist err
              client2.disconnect()

              @client.joinChat {chatId: chatId}, (err, data) =>

                @client.getMyChats (err, data) =>
                  should.not.exist err
                  data.length.should.eql 1
                  chatData = data[0]
                  chatData.visitor.username.should.eql 'joinMe'
                  should.exist chatData.visitor.referrerData.arbitrary, 'expected referrerData'
                  chatData.visitor.referrerData.arbitrary.should.eql 'someValue'
                  chatData.status.should.eql 'waiting'
                  new Date chatData.creationDate #just need this to not cause an error
                  done()
