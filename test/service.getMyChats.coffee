require 'should'
boiler = require './util/boilerplate'

boiler 'Service - Get My Chats', (globals) ->
  it "should return data on all of a particular operator's chats", (done)->
    client = globals.getClient()
    client.ready ->
      data = {username: 'joinMe'}
      client.newChat data, (err, data)->
        channel = client.cookie 'channel'
        client.cookie 'channel', null
        client.cookie 'session', null
        client.disconnect()

        client2 = globals.getClient()
        client2.ready ->
          data = {username: 'butNotMe'}
          client2.newChat data, (err, data)->
            client2.disconnect()

            loginData =
              email: 'god@torchlightsoftware.com'
              password: 'foobar'
            client3 = globals.getClient()
            client3.ready ->
              client3.login loginData, ->
                client3.joinChat channel, (err, data)->

                  client3.getMyChats (err, data)->
                    client3.disconnect()
                    false.should.eql err?
                    data.length.should.eql 1
                    chatData = data[0]
                    chatData.visitor.username.should.eql 'joinMe'
                    chatData.visitorPresent.should.eql true
                    new Date chatData.creationDate #just need this to not cause an error
                    done()
