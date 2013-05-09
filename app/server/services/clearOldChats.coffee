async = require 'async'
sugar = require 'sugar'
# stoic = require 'stoic'
mongo = config.require 'load/mongo'

removeUnanswered = config.require 'services/operator/removeUnanswered'

# {Chat, ChatSession, Session} = stoic.models
{ChatHistory, Account} = mongo.models

getChatModels = (accountId) ->
  (chatIds, next) ->
    next null, chatIds.map (chatId) -> Chat(accountId).get(chatId)

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

archiveChats = (accountId) ->
  (chats, next) ->

    archive = (chat, next) ->
      async.parallel {
        chatData: chat.dump
        chatSessions: ChatSession(accountId).getByChat chat.id

      }, (err, {chatData, chatSessions}) ->
        return next err if err

        getOperatorId = (chatSession, next) ->
          chatSession.session.operatorId.get next

        async.map chatSessions, getOperatorId, (err, operators) ->

          chatRecord =
            accountId: accountId
            visitor: chatData.visitor
            creationDate: chatData.creationDate
            history: chatData.history
            operators: operators

          ChatHistory.create chatRecord, next

    async.forEach chats, archive, ->
      next null, chats

deleteChats = (accountId) ->
  (chats, next) ->
    removeChat = (chat, next) -> chat.delete next
    async.forEach chats, removeChat, next

processAccount = (account, next) ->
  accountId = account._id
  async.waterfall [
    Chat(accountId).allChats.members
    getChatModels accountId
    getOldChats
    archiveChats accountId
    deleteChats accountId

  ], next

module.exports = (done) ->
  Account.find {}, {_id: true}, (err, accounts) ->
    async.forEach accounts, processAccount, done
