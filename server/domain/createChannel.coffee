redisFactory = require '../redis'

module.exports = (serviceName, veinServer, cb)->
  unless veinServer.services[serviceName]?
    redisFactory (redis)->
      veinServer.add serviceName, (res, message)->
        data =
          message: message
          username: res.cookie 'username'
          timestamp: Date.now()

        redis.chats.addMessage serviceName, data, (err)->
          console.log "error caching message: #{err}" if err

        res.publish null, data
      cb()