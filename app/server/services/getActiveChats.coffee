async = require 'async'
stoic = require 'stoic'
{Chat} = stoic.models

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'
filterRelevant = config.require 'services/chats/filterRelevant'

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    chatDataForAccount = (chatId, next) ->
      getFullChatData accountId, chatId, next

    Chat(accountId).allChats.all (err, chatIds) ->

      getChatRelations accountId, sessionId, (err, relations) ->
        config.log.error 'Error getting chat relations in getActiveChats', {error: err, sessionId: sessionId} if err

        async.map chatIds, chatDataForAccount, (err, chats) ->
          config.log.error 'Error mapping chat data in getActiveChats', {error: err, sessionId: sessionId, chatIds: chatIds} if err

          chat.relation = relations[chat.id] for chat in chats

          #Remove chats that have a vacant status
          chats = chats.remove (chat) -> chat.status is 'vacant'
          chats = chats.sortBy(chatPriority)

          filterRelevant accountId, sessionId, chats, done
