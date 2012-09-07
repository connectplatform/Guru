async = require 'async'
stoic = require 'stoic'
getVisibleOperators = config.require 'services/chats/getVisibleOperators'

module.exports = (chatId, next) ->
  {Chat, ChatSession} = stoic.models

  async.parallel [
    Chat.get(chatId).dump
    ChatSession.getByChat chatId

  ], (err, [chat, chatSessions]) ->
    console.log "Error getting chat from cache: chatId: #{chatId}, error:#{err}" if err?

    # date parsing should be moved to Stoic type
    message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history

    getVisibleOperators chatSessions, (err, visibleOperators) ->
      chat.operators = visibleOperators
      next err, chat

