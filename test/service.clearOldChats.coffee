should = require 'should'
stoic = require 'stoic'
async = require 'async'
boiler = require './util/boilerplate'
sugar = require 'sugar'

createChat = (chat, cb) ->
  {Chat} = stoic.models
  Chat.create (err, c) ->
    async.parallel [
      c.visitor.mset chat.visitor
      c.status.set chat.status
      c.creationDate.set chat.creationDate
    ], (err) ->

      pushHistory = (historyItem, cb) ->
        c.history.rpush historyItem, cb

      async.forEach chat.history, pushHistory, ->
        cb err, c

getOldChats = ->
  halfHourAgo = Date.create("30 minutes ago")
  almostHalfHourAgo = Date.create("29 minutes ago")
  return [
    {
      visitor:
        username: 'Bob'
      status: 'waiting'
      creationDate: halfHourAgo
      history: []
    }
    {
      visitor:
        username: 'Frank'
      status: 'vacant'
      creationDate: halfHourAgo
      history: [
        {
          message: 'Hi'
          username: 'person'
          timestamp: almostHalfHourAgo
        }
      ]
    }
  ]

boiler 'Service - Delete Old Chats', ->
  it 'should delete old chats', (done) ->
    clearOldChats = require '../server/domain/clearOldChats'
    {Chat} = stoic.models
    async.map getOldChats(), createChat, ->
      clearOldChats (err) ->
        should.not.exist err
        Chat.allChats.members (err, allChats) ->
          should.not.exist err
          allChats.length.should.eql 0
          done()

  it 'should not delete new chats', (done) ->
    clearOldChats = require '../server/domain/clearOldChats'
    {Chat} = stoic.models

    now = Date.create()
    halfHourAgo = Date.create("30 minutes ago")
    chats = [
      {
        visitor:
          username: 'Bob'
        status: 'waiting'
        creationDate: now
        history: []
      }
      {
        visitor:
          username: 'Frank'
        status: 'vacant'
        creationDate: halfHourAgo
        history: [
          {
            message: 'Hi'
            username: 'person'
            timestamp: now
          }
        ]
      }
    ]

    async.map chats, createChat, ->
      clearOldChats (err) ->
        should.not.exist err
        Chat.allChats.members (err, allChats) ->
          should.not.exist err
          allChats.length.should.eql 2
          done()

  it 'should remove operators from the deleted chats', (done) ->
    clearOldChats = require '../server/domain/clearOldChats'
    {Chat} = stoic.models
    async.map getOldChats(), createChat, (err, chats) =>
      chatId = chats[0].id

      #make sure user has properly joined chat
      @getAuthed =>
        @client.joinChat chatId, (err) =>
          should.not.exist err
          @client.getMyChats (err, chats) =>
            should.not.exist err
            chats.length.should.eql 1

            #delete the chat
            clearOldChats (err) =>
              should.not.exist err
              Chat.allChats.members (err, allChats) =>
                should.not.exist err
                allChats.length.should.eql 0

                #check that operator was properly removed
                @client.getMyChats (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 0
                  done()

  it 'should let a visitor create a new chat if their old one was deleted', (done) ->
    clearOldChats = require '../server/domain/clearOldChats'
    {Chat} = stoic.models

    #create the chat
    visitor = @getClient()
    visitor.ready ->
      newChatData = {username: 'visitor'}
      visitor.newChat newChatData, (err, createdChat) ->
        visitorSession = visitor.cookie 'session'
        chatChannelName = createdChat.channel

        #modify the chat's creation date
        chat = Chat.get chatChannelName
        chat.creationDate.set Date.create("30 minutes ago"), (err) ->
          should.not.exist err

          #delete the chat
          clearOldChats (err) =>
            should.not.exist err

            #Chat should delete, even with user in it
            Chat.allChats.members (err, allChats) =>
              should.not.exist err
              allChats.length.should.eql 0

              #Create a new chat and make sure it's different than the one we had
              visitor.newChat newChatData, (err, createdChat) ->
                should.not.exist err
                visitorSession.should.not.eql visitor.cookie 'session'
                chatChannelName.should.not.eql createdChat.channel
                done()
