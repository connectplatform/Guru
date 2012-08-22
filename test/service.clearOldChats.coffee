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

boiler 'Service - Get Chat Stats', ->
  it 'should delete old chats', (done) ->
    clearOldChats = require '../server/domain/clearOldChats'
    {Chat} = stoic.models

    halfHourAgo = Date.create("30 minutes ago")
    almostHalfHourAgo = Date.create("29 minutes ago")
    chats = [
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

    async.map chats, createChat, ->
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
