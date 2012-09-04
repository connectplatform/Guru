stoic = require 'stoic'
async = require 'async'
sugar = require 'sugar'
{Chat, ChatSession} = stoic.models

shouldDeleteChat = (chat, minutesToTimeout, cb) ->
  dateCutoff = Date.create("#{minutesToTimeout} minutes ago")
  chat.history.len (err, historyLength) ->
    return cb err, false if err
    if historyLength > 0
      chat.history.index -1, (err, lastMessage) ->
        cb err, Date.create(JSON.parse(lastMessage).timestamp) < dateCutoff
    else
      chat.creationDate.get (err, creationDate) ->
        cb err, creationDate < dateCutoff

deleteChatSession = (chatSession, cb) ->
  ChatSession.remove chatSession.sessionId, chatSession.chatId, cb

removeOldChats = (chat, minutesToTimeout, cb) ->
  shouldDeleteChat chat, minutesToTimeout, (err, shouldDelete) ->
    return cb err if err
    if shouldDelete
      #remove all operators from the chat
      ChatSession.getByChat chat.id, (err, chatSessions) ->
        async.forEach chatSessions, deleteChatSession, (err) ->
          console.log "error deleting chat session: #{err}" if err

          #delete chat
          async.parallel [
            chat.delete
            Chat.allChats.srem chat.id
            Chat.unansweredChats.srem chat.id
          ], cb

    else
      cb null

#TODO: refactor so that the pipeline 1) filters, 2) removes
# next add an additional step to archive to mongo
module.exports = (cb) ->
  Chat.allChats.members (err, chatIds) ->
    return cb err if err

    chats = chatIds.map (chatId) -> Chat.get(chatId)

    minutesToTimeout = 15

    removalIterator = (chat, cb) ->
      removeOldChats chat, minutesToTimeout, cb

    async.forEach chats, removalIterator, (err) ->
      cb err

