async = require 'async'
{tandoor, compact, getType} = config.require 'load/util'

stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = tandoor (sessionId, relationTypes, done) ->
  if getType(relationTypes) != '[object Array]'
    relationTypes = [relationTypes]

  filter = (rel, next) ->
    rel.relationMeta.get 'type', (err, type) ->
      #console.log 'found type:', type
      #console.log 'looking for:', relationTypes
      if type in relationTypes
        next null, {chatId: rel.chatId, type: type}
      else
        next()

  ChatSession.get(sessionId).sessionIndex.members (err, chats) ->
    async.map chats, filter, (err, chats) ->
      chats = compact chats if chats?
      done err, chats
