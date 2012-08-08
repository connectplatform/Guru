require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Join Chat', ->

  it 'should associate an operator with a chat', (done) ->
    visitorClient = @getClient()
    visitorClient.ready =>
      visitorClient.newChat {username: 'foo'}, (err, {channel}) =>
        visitorClient.disconnect()

        @getAuthed =>
          @client.joinChat channel, (err) =>
            false.should.eql err?
            id = @client.cookie('session')

            #TODO refactor this to check at a higher level than cache contents
            {ChatSession} = redgoose.models
            ChatSession.getBySession id, (err, [chat]) =>
              false.should.eql err?
              chat.chatId.should.eql channel
              done()
