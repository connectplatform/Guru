async = require 'async'
stoic = require 'stoic'

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'
filterRelevant = config.require 'services/chats/filterRelevant'

module.exports = ({sessionId}, done) ->
  {Session, Chat} = stoic.models

  Session.accountLookup.get sessionId, (err, accountId) ->
    chatDataForAccount = (chatId, next) ->
      getFullChatData accountId, chatId, next

    Chat(accountId).allChats.all (err, chatIds) ->

      getChatRelations accountId, sessionId, (err, relations) ->
        config.log.error 'Error getting chat relations in getActiveChats', {error: err, sessionId: sessionId} if err

        async.map chatIds, chatDataForAccount, (err, chats) ->
          config.log.error 'Error mapping chat data in getActiveChats', {error: err, sessionId: sessionId, chatIds: chatIds} if err

          chat.relation = relations[chat.id] for chat in chats
          chats = chats.sortBy(chatPriority)

          filterRelevant accountId, sessionId, chats, done
