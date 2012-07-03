redis = require '../redis'

module.exports = (serviceName, veinServer, cb)->
  unless veinServer.services[serviceName]?
    veinServer.add serviceName, (res, message)->
      redis.sessions.chatName unescape(res.cookie('session')), (err, username)->
        console.log "Error getting chat name from cache: #{err}" if err
        data =
          message: message
          username: username
          timestamp: Date.now()

        redis.chats.addMessage serviceName, data, (err)->
          console.log "error caching message: #{err}" if err

        res.publish null, data
        res.send null, "ack"

    cb()