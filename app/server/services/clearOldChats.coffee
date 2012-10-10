async = require 'async'
sugar = require 'sugar'
stoic = require 'stoic'
mongo = config.require 'load/mongo'

removeUnanswered = config.require 'services/operator/removeUnanswered'

{Chat, ChatSession, Session} = stoic.models
{ChatHistory} = mongo.models

getChatModels = (chatIds, next) ->
  next null, chatIds.map (chatId) -> Chat.get(chatId)

getOldChats = (chats, next) ->

  shouldDeleteChat = (chat, cb) ->
    {minutesToTimeout} = config.app.chats
    dateCutoff = Date.create("#{minutesToTimeout} minutes ago")
    chat.history.len (err, historyLength) ->
      return cb false if err
      if historyLength > 0
        chat.history.index -1, (err, lastMessage) ->
          cb Date.create(JSON.parse(lastMessage).timestamp) < dateCutoff
      else
        chat.creationDate.get (err, creationDate) ->
          cb creationDate < dateCutoff

  async.filter chats, shouldDeleteChat, (filteredChats) ->
    next null, filteredChats

archiveChats = (chats, next) ->

  archive = (chat, next) ->
    async.parallel {
      chatData: chat.dump
      chatSessions: ChatSession.getByChat chat.id

    }, (err, {chatData, chatSessions}) ->
      return next err if err?

      getOperatorId = (chatSession, next) ->
        chatSession.session.operatorId.get next

      async.map chatSessions, getOperatorId, (err, operators) ->

        chatRecord =
          visitor: chatData.visitor
          creationDate: chatData.creationDate
          history: chatData.history
          operators: operators

        ChatHistory.create chatRecord, next

  async.forEach chats, archive, ->
    next null, chats

deleteChats = (chats, next) ->
  deleteChatSession = (chatSession, cb) ->
    async.parallel [
      ChatSession.remove chatSession.sessionId, chatSession.chatId
      Session.get(chatSession.sessionId).unreadMessages.hdel chatSession.chatId
    ], cb

  removeOldChats = (chat, next) ->
    # get related chatsessions
    ChatSession.getByChat chat.id, (err, chatSessions) ->

        #delete everything
        async.parallel [
          (next) -> async.forEach chatSessions, deleteChatSession, next
          chat.delete
          Chat.allChats.srem chat.id
          Chat.unansweredChats.srem chat.id
          removeUnanswered chat.id
        ], next

  async.forEach chats, removeOldChats, next

module.exports = (done) ->
  async.waterfall [
    Chat.allChats.members
    getChatModels
    getOldChats
    archiveChats
    deleteChats

  ], done
