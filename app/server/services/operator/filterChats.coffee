async = require 'async'
{tandoor, compact, getType} = config.require 'load/util'

stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = tandoor (chatSessions, relationTypes, done) ->
  if getType(relationTypes) != 'Array'
    relationTypes = [relationTypes]

  filter = (chatSession, next) ->
    chatSession.relationMeta.get 'type', (err, type) ->
      config.log.error 'Error getting chat relation type in filterChats', {error: err, chatId: chatSession?.chatId, sessionId: chatSession?.sessionId} if err
      if type in relationTypes
        next null, {chatId: chatSession.chatId, type: type}
      else
        next()

  async.map chatSessions, filter, (err, chats) ->
    chats = compact chats if chats?
    done err, chats
