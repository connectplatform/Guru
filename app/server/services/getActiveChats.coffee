async = require 'async'
# stoic = require 'stoic'
# {Chat} = stoic.models

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
      return done err if err

      async.parallel {
        relations: (next) -> getChatRelations accountId, sessionId, next
        chats: (next) -> async.map chatIds, chatDataForAccount, next

      }, (err, {chats, relations}) ->
        return done err if err

        chat.relation = relations[chat.id] for chat in chats

        #Remove chats that have a vacant status
        chats = chats.remove (chat) -> chat.status is 'vacant'
        chats = chats.sortBy(chatPriority)

        filterRelevant accountId, sessionId, chats, done
