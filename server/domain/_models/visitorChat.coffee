{tandoor} = require '../../../lib/util'
# Interface for document
face = (decorators) ->

  {visitorChat: {byChat, byVisitor}} = decorators

  #TODO: pull this into redgoose, refactor here
  call = (decorator, id, method, args...) ->
    obj = {}
    decorator obj
    decoratorName = Object.keys(obj)[0]
    obj.id = id
    obj[decoratorName][method] args...

  visitorChat =
    add: tandoor (visitorId, chatId, cb) ->
      #TODO

  return visitorChat

# Schema for document
schema =

  'visitorChat':
    'byVisitor!{id}:byChat:!{id}': 'Hash'

# Name, Interface, Schema
module.exports = ['VisitorChat', face, schema]