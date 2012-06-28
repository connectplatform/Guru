redisFactory = require '../redis'

module.exports = (serviceName, veinServer, cb)->
  console.log "about to create channel"
  unless veinServer.services[serviceName]?
    redisFactory (redis)->
      veinServer.add serviceName, (res, message)->
        console.log "session: #{res.cookie('session')}"
        redis.sessions.chatName unescape(res.cookie('session')), (err, username)->
          console.log "username found in cache: #{username}"
          console.log "Error getting chat name from cache: #{err}" if err
          data =
            message: message
            username: username
            timestamp: Date.now()

          redis.chats.addMessage serviceName, data, (err)->
            console.log "error caching message: #{err}" if err

          res.publish null, data

      console.log "created channel"
      cb()