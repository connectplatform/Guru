async = require 'async'
stoic = config.require 'load/initStoic'

getFullChatData = config.require 'services/chats/getFullChatData'
chatPriority = config.require 'services/chats/chatPriority'
getChatRelations = config.require 'services/chats/getChatRelations'
getOperatorData = config.require 'services/operator/getOperatorData'

module.exports = (res) ->
  session = res.cookie 'session'
  {Chat, ChatSession} = stoic.models
  getOperatorData session, (err, my) ->

    isRelevant = (chat) ->
      return true if chat.relation?
      return true if my.role in ['Administrator', 'Supervisor']
      return false if chat.website not in my.websites
      return false if chat.department and chat.department.toLowerCase() not in my.specialties.map((s)-> s.toLowerCase())
      return true

    Chat.allChats.all (err, chatIds) ->

      getChatRelations session, (err, relations) ->

        async.map chatIds, getFullChatData, (err1, chats) ->

          chat.relation = relations[chat.id] for chat in chats
          chats = chats.filter(isRelevant).sortBy(chatPriority)
          res.reply err, chats
