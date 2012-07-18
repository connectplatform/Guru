{tandoor} = require '../../../lib/util'
async = require 'async'
# Interface for document
face = (decorators) ->

  {operatorChat: {byChat, byOperator, relationMeta}} = decorators

  #TODO pull this into redgoose, refactor here
  call = (decorator, id, method, args...) ->
    obj = {}
    decorator obj
    decoratorName = Object.keys(obj)[0]
    obj.id = id
    obj[decoratorName][method] args...

  packageMeta = (operatorId, chatId) ->
    obj = chatId: chatId, operatorId: operatorId
    relationMeta obj
    obj

  callRelation = (operatorId, chatId, method, args...) ->
    obj = packageMeta operatorId, chatId
    obj.relationMeta[method] args...

  operatorChat =
    add: tandoor (operatorId, chatId, metaInfo, cb) ->
      async.parallel [
        call byOperator, operatorId, "add", chatId
        call byChat, chatId, "add", operatorId
#        callRelation operatorId, chatId, "set", 'isWatching', metaInfo.isWatching #TODO: run through elements automatically
        callRelation operatorId, chatId, "mset", metaInfo
      ], (err) ->

        console.log "Error adding operatorChat: #{err}" if err?
        cb err, true

    remove: tandoor (operatorId, chatId, cb) ->
      async.parallel [
        call byOperator, operatorId, "srem", chatId
        call byChat, chatId, "srem", operatorId
        callRelation operatorId, chatId, "del"
        ], (err) ->

          console.log "Error adding operatorChat: #{err}" if err?
          cb err, true

    getChatsByOperator: tandoor (operatorId, cb) ->
      call byOperator, operatorId, "members", (err, chatIds) ->
        result = (packageMeta operatorId, chatId for chatId in chatIds)
        cb err, result

    getOperatorsByChat: tandoor (chatId, cb) ->
      call byChat, chatId, "members", (err, operatorIds) ->
        result = (packageMeta operatorId, chatId for operatorId in operatorIds)
        cb err, result

  return operatorChat

# Schema for document
schema =

  'operatorChat':
    'byOperator:!{id}': 'Set' 
    'byChat:!{id}': 'Set' 
    'relationMeta:!{operatorId}:!{chatId}': 'Hash'

# Name, Interface, Schema
module.exports = ['OperatorChat', face, schema]
