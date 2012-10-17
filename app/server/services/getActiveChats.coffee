async = require 'async'
stoic = require 'stoic'

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'
filterRelevant = config.require 'services/chats/filterRelevant'

module.exports = (res) ->
  sessionId = res.cookie 'session'
  {Chat, ChatSession} = stoic.models

  Chat.allChats.all (err, chatIds) ->

    getChatRelations sessionId, (err, relations) ->
      config.log.error 'Error getting chat relations in getActiveChats', {error: err, sessionId: sessionId} if err

      async.map chatIds, getFullChatData, (err, chats) ->
        config.log.error 'Error mapping chat data in getActiveChats', {error: err, sessionId: sessionId, chatIds: chatIds} if err

        chat.relation = relations[chat.id] for chat in chats
        chats = chats.sortBy(chatPriority)

        filterRelevant sessionId, chats, res.reply
