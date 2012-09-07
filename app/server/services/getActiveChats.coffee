async = require 'async'
stoic = require 'stoic'

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'

module.exports = (res) ->
  {Chat, ChatSession} = stoic.models

  getChatRelations res.cookie('session'), (err, relations) ->

    Chat.allChats.all (err, chatIds) ->
      async.map chatIds, getFullChatData, (err1, chats) ->
        chat.relation = relations[chat.id] for chat in chats
        chats = chats.sortBy chatPriority
        res.reply err, chats
