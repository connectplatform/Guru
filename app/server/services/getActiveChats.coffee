async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession} = db.models

# chatPriority = config.require 'services/chats/chatPriority'
# filterRelevant = config.require 'services/chats/filterRelevant'

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    Chat.find {accountId}, (err, chats) ->
      done err, null if err
      return done null, {chats}
      
    # ChatSession.find {sessionId}, (err, chatSessions) ->
    #   console.log {err, chatSessions}
    #   chatIds = (cs.chatId for cs in chatSessions)
    #   Chat.find {_id: '$in': chatIds}, (err, chats) ->
    #     done err, null if err
    #     return done null, {chats}
      
      
    # chatDataForAccount = (chatId, next) ->
    #   getFullChatData accountId, chatId, next

    # Chat(accountId).allChats.all (err, chatIds) ->
    #   return done err if err

    #   async.parallel {
    #     relations: (next) -> getChatRelations accountId, sessionId, next
    #     chats: (next) -> async.map chatIds, chatDataForAccount, next

    #   }, (err, {chats, relations}) ->
    #     return done err if err

    #     chat.relation = relations[chat.id] for chat in chats

    #     #Remove chats that have a vacant status
    #     chats = chats.remove (chat) -> chat.status is 'vacant'
    #     chats = chats.sortBy(chatPriority)

    #     filterRelevant accountId, sessionId, chats, done
