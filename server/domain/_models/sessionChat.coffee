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

  packageMeta = (sessionId, chatId) ->
    obj = chatId: chatId, sessionId: sessionId
    relationMeta obj
    obj

  callRelation = (sessionId, chatId, method, args...) ->
    obj = packageMeta sessionId, chatId
    obj.relationMeta[method] args...

  sessionChat =
    add: tandoor (sessionId, chatId, metaInfo, cb) ->
      async.parallel [
        call bySession, sessionId, "add", chatId
        call byChat, chatId, "add", sessionId
#        callRelation sessionId, chatId, "set", 'isWatching', metaInfo.isWatching #TODO: run through elements automatically
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

          console.log "Error adding sessionChat: #{err}" if err?
          cb err, true

    getChatsBySession: tandoor (sessionId, cb) ->
      call bySession, sessionId, "members", (err, chatIds) ->
        result = (packageMeta sessionId, chatId for chatId in chatIds)
        cb err, result

    getSessionsByChat: tandoor (chatId, cb) ->
      call byChat, chatId, "members", (err, sessionIds) ->
        result = (packageMeta sessionId, chatId for sessionId in sessionIds)
        cb err, result

  return sessionChat

# Schema for document
schema =

  'sessionChat':
    'bySession:!{id}': 'Set' 
    'byChat:!{id}': 'Set' 
    'relationMeta:!{sessionId}:!{chatId}': 'Hash'

# Name, Interface, Schema
module.exports = ['SessionChat', face, schema]
