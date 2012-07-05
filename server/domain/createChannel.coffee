redis = require '../redis'
redgoose = require 'redgoose'

module.exports = (serviceName, veinServer, cb)->
  unless veinServer.services[serviceName]?
    veinServer.add serviceName, (res, message)->

      sessionId = unescape(res.cookie('session'))
      {Session} = redgoose.models
      Session.get(sessionId).chatName.get (err, username)->

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