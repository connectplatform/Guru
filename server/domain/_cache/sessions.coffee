rand = require '../../../lib/rand'
module.exports = (client)->
  create: (role, foreignKey, cb)->
    id = "#{rand()}"
    client.set "sessions:#{id}:role", role, (err, data)->
      console.log "error caching session role: #{err}" if err
      client.set "sessions:#{id}:foreignKey", foreignKey, (err, data)->
        console.log "error caching session foreignKey: #{err}" if err
        cb id

  setChatName: (id, chatName, cb)->
    client.set "sessions:#{id}:chatName", chatName, cb

  chatName: (id, cb)->
    client.get "sessions:#{id}:chatName", cb

  role: (id, cb)->
    client.get "sessions:#{id}:role", cb