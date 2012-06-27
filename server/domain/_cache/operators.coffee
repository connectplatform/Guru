module.exports = (client) -> 
  login: (mongoId, cb)->
    id = "operator:#{mongoId}"
    client.sadd "operator:allOperators", id, cb id

  getOperatorIds: (cb)->
    client.smembers "operator:allOperators", cb

  addChat: (id, chatId, cb)->
    client.sadd "#{id}:chats", chatId, cb

  removeChat: (id, chatId, cb)->
    client.srem "#{id}:chats", chatId, cb

  chats: (id, cb)->
    client.smembers "#{id}:chats", cb