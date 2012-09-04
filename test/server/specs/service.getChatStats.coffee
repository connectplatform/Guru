should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Chat Stats', ->

  it 'should return chat statistics', (done) ->
    @createChats (err, chats) =>
      targetChat = chats[0].id
      @getAuthed =>
        {ChatSession} = stoic.models
        ChatSession.add @client.cookie('session'), targetChat, {type: 'invite'}, =>
          @client.getChatStats (err, stats) =>
            should.not.exist err

            {invites, invites: [{chatId, type}]} = stats # destructure me, baby
            invites.length.should.eql 1
            chatId.should.eql targetChat
            type.should.eql 'invite'
            done()
