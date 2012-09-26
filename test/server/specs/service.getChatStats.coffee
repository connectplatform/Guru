should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Chat Stats', ->

  it 'should return chat statistics', (done) ->
    {ChatSession} = stoic.models

    @getAuthed =>
      session = @client.cookie 'session'

      @createChats (err, chats) =>
        targetChat = chats[0].id

        ChatSession.add session, targetChat, {type: 'invite'}, =>
          @client.getChatStats (err, stats) =>
            should.not.exist err

            {invites, invites: [{chatId, type}]} = stats # destructure me, baby
            invites.length.should.eql 1
            chatId.should.eql targetChat
            type.should.eql 'invite'
            done()
