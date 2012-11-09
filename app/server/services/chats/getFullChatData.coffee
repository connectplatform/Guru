async = require 'async'

stoic = require 'stoic'
{Chat, ChatSession} = stoic.models

db = require 'mongoose'
{Website} = db.models

getVisibleOperators = config.require 'services/chats/getVisibleOperators'

module.exports = (accountId, chatId, next) ->

  async.parallel [
    Chat(accountId).get(chatId).dump
    ChatSession(accountId).getByChat chatId

  ], (err, [chat, chatSessions]) ->
    if err
      meta = {error: err, chatId: chatId, chat: chat, chatSessions: chatSessions}
      config.log.error 'Error getting chat and chatSession in getFullChatData', meta

    Website.findOne {_id: chat.website}, {url: true}, (err, website) ->
      chat.website = website

      # get visible participants for this chat
      getVisibleOperators chatSessions, (err, visibleOperators) ->
        config.log.error 'Error getting visible operators in getFullChatData', {error: err, chatId: chatId, chatSessions: chatSessions, visibleOperators: visibleOperators} if err
        message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history
        chat.operators = visibleOperators
        next err, chat
