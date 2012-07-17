{tandoor} = require '../../../lib/util'
# Interface for document
face = (decorators) ->

  {operatorChat: {byChat, byOperator}} = decorators

  #TODO pull this into redgoose, refactor here
  call = (decorator, id, method, args...) ->
    obj = {}
    decorator obj
    decoratorName = Object.keys(obj)[0]
    obj.id = id
    obj[decoratorName][method] args...

  operatorChat =
    add: tandoor (operatorId, chatId, isWatching, cb) ->
      call byOperator, operatorId, "set", chatId, isWatching, ->
        call byChat, chatId, "set", operatorId, isWatching, cb

    getChatsByOperator: tandoor (operatorId, cb) ->
      call byOperator, operatorId, "getall", cb

    getOperatorsByChat: tandoor (chatId, cb) ->
      call byChat, chatId, "getall", cb

  return operatorChat

# Schema for document
schema =

  # This should probably be refactored into:
  # 'byOperator!{id}:byChat:!{id}': 'Hash'

  'operatorChat':
    'byOperator!{id}': 'Hash' # key: chatID, value: isWatching
    'byChat:!{id}': 'Hash' # key: operatorID, value: isWatching

# Name, Interface, Schema
module.exports = ['OperatorChat', face, schema]
