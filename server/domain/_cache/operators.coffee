rand = require '../../../lib/rand'
module.exports = (client) -> 
  login: (mongoId, cb)->
    id = "operator:#{rand()}"
    client.set "operator:#{id}:session", mongoId, (err, data)->
      console.log "error caching session id at login: #{err}" if err
      client.expire "operator:#{id}:session", 3600, (err, data)->
        console.log "error setting session id timeout at login: #{err}" if err
        cb id

  isLoggedin: (id, cb)->
    client.get "operator:id:session", (err, data)->
      console.log "error searching for operator #{err}" if err
      cb null, data if data? and !!data else cb null, false

  addChat: (id, chatId, cb)->
    client.sadd "#{id}:chats", chatId, cb

  removeChat: (id, chatId, cb)->
    client.srem "#{id}:chats", chatId, cb

  chats: (id, cb)->
    client.smembers "#{id}:chats", cb