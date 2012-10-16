async = require 'async'
stoic = require 'stoic'

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'
filterRelevant = config.require 'services/chats/filterRelevant'

module.exports = (res) ->
  session = res.cookie 'session'
  {Chat, ChatSession} = stoic.models

  Chat.allChats.all (err, chatIds) ->

    getChatRelations session, (err, relations) ->
      console.log 'Error:', err if err

      async.map chatIds, getFullChatData, (err1, chats) ->

        chat.relation = relations[chat.id] for chat in chats
        chats = chats.sortBy(chatPriority)

        filterRelevant session, chats, res.reply
