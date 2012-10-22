async = require 'async'
stoic = require 'stoic'
getVisibleOperators = config.require 'services/chats/getVisibleOperators'

module.exports = (accountId, chatId, next) ->
  {Chat, ChatSession} = stoic.models

  async.parallel [
    Chat(accountId).get(chatId).dump
    ChatSession(accountId).getByChat chatId

  ], (err, [chat, chatSessions]) ->
    config.log.error 'Error getting chat and chatSession in getFullChatData', {error: err, chatId: chatId, chat: chat, chatSessions: chatSessions} if err

    # get visible participants for this chat
    getVisibleOperators chatSessions, (err, visibleOperators) ->
      config.log.error 'Error getting visible operators in getFullChatData', {error: err, chatId: chatId, chatSessions: chatSessions, visibleOperators: visibleOperators} if err
      message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history
      chat.operators = visibleOperators
      next err, chat
