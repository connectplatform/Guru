rand = require '../../../lib/rand'
module.exports = (client) -> 
  addChat: (id, chatId, cb)->
    console.log "adding chat:#{chatId} for operator #{id}"
    client.sadd "operators:#{id}:chats", chatId, cb

  removeChat: (id, chatId, cb)->
    client.srem "operators:#{id}:chats", chatId, cb

  chats: (id, cb)->
    console.log "looking for chats for #{id}"
    client.smembers "operators:#{id}:chats", cb