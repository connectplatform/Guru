stoic = require 'stoic'
async = require 'async'
sugar = require 'sugar'
{Chat} = stoic.models

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

removeOldChats = (chat, minutesToTimeout, cb) ->
  shouldDeleteChat chat, minutesToTimeout, (err, shouldDelete) ->
    return cb err if err
    if shouldDelete

      async.parallel [
        chat.delete
        Chat.allChats.srem chat.id
        Chat.unansweredChats.srem chat.id
      ], cb

    else
      cb null

module.exports = (cb) ->
  Chat.allChats.members (err, chatIds) ->
    return cb err if err

    chats = chatIds.map (chatId) -> Chat.get(chatId)

    minutesToTimeout = 15

    removalIterator = (chat, cb) ->
      removeOldChats chat, minutesToTimeout, cb

    async.forEach chats, removalIterator, (err) ->
      cb err

