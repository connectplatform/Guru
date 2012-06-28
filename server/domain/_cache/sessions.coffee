rand = require '../../../lib/rand'
module.exports = (client)->
  create: (role, foreignKey, cb)->
    id = "sessions:#{rand()}"
    client.set "#{id}:role", role, (err, data)->
      console.log "error caching session role: #{err}" if err
      client.set "#{id}:foreignKey", foreignKey, (err, data)->
        console.log "error caching session foreignKey: #{err}" if err
        cb id

  setChatName: (id, chatName, cb)->
    client.set "#{id}:chatName", chatName, cb

  chatName: (id, cb)->
    client.get "#{id}:chatName", cb

  setRole: (id, role, cb)->
    client.set "#{id}:role", role, cb

  role: (id, cb)->
    client.get "#{id}:role", cb