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
    add: (operatorId, chatId, isWatching, cb)->
      call byOperator, operatorId, "set", chatId, isWatching, ->
        call byChat, chatId, "set", operatorId, isWatching, cb

    getChatsByOperator: (operatorId, cb)->
      call byOperator, operatorId, "getall", cb

    getOperatorsByChat: (chatId, cb)->
      call byChat, chatId, "getall", cb

  return operatorChat

# Schema for document
schema =
  'operatorChat':
    'byOperator!{id}': 'Hash'
    'byChat:!{id}': 'Hash'

# Name, Interface, Schema
module.exports = ['OperatorChat', face, schema]