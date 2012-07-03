rand = require '../../../lib/rand'
module.exports = (client) -> 
  addChat: (id, chatId, cb)->
    client.sadd "operators:#{id}:chats", chatId, cb

  removeChat: (id, chatId, cb)->
    client.srem "operators:#{id}:chats", chatId, cb

  chats: (id, cb)->
    client.smembers "operators:#{id}:chats", cb