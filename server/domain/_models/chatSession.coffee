redgoose = require 'redgoose'
{Chat, Session} = redgoose.models

{tandoor} = require '../../../lib/util'
async = require 'async'
# Interface for document
face = (decorators) ->

  {sessionChat: {byChat, bySession, relationMeta}} = decorators

  #TODO pull this into redgoose, refactor here
  call = (decorator, id, method, args...) ->
    obj = {}
    decorator obj
    decoratorName = Object.keys(obj)[0]
    obj.id = id
    obj[decoratorName][method] args...

  packageRelation = (sessionId, chatId) ->
    obj = chatId: chatId, sessionId: sessionId
    relationMeta obj
    obj.session = Session.get sessionId
    obj.chat = Chat.get chatId
    obj

  callRelation = (sessionId, chatId, method, args...) ->
    obj = chatId: chatId, sessionId: sessionId
    relationMeta obj
    obj.relationMeta[method] args...

  sessionChat =
    add: tandoor (sessionId, chatId, metaInfo, cb) ->
      {inspect} = require 'util'
      async.parallel [
        call bySession, sessionId, "add", chatId
        call byChat, chatId, "add", sessionId
        callRelation sessionId, chatId, "mset", metaInfo
      ], (err) ->

        console.log "Error adding sessionChat: #{err}" if err?
        cb err, true

    remove: tandoor (sessionId, chatId, cb) ->
      async.parallel [
        call bySession, sessionId, "srem", chatId
        call byChat, chatId, "srem", sessionId
        callRelation sessionId, chatId, "del"
        ], (err) ->

          console.log "Error removing sessionChat: #{err}" if err?
          cb err, true

    getBySession: tandoor (sessionId, cb) ->
      call bySession, sessionId, "members", (err, chatIds) ->
        result = (packageRelation sessionId, chatId for chatId in chatIds)
        cb err, result

    getByChat: tandoor (chatId, cb) ->
      call byChat, chatId, "members", (err, sessionIds) ->
        result = (packageRelation sessionId, chatId for sessionId in sessionIds)
        cb err, result

  return sessionChat

# Schema for document
schema =

  'sessionChat':
    'bySession:!{id}': 'Set'
    'byChat:!{id}': 'Set'
    'relationMeta:!{sessionId}:!{chatId}': 'Hash'
    # meta keys: isWatching: true|false
    #            type: member|invite|transfer
    #            requestor: sessionID (optional)

module.exports = ['ChatSession', face, schema]
