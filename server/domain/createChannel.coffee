redgoose = require 'redgoose'

module.exports = (serviceName, veinServer, cb)->
  unless veinServer.services[serviceName]?
    veinServer.add serviceName, (res, message)->

      {Session, Chat} = redgoose.models

      sessionId = unescape(res.cookie('session'))
      Session.get(sessionId).chatName.get (err, username)->

        console.log "Error getting chat name from cache: #{err}" if err
        data =
          message: message
          username: username
          timestamp: Date.now()

        Chat.get(serviceName).history.add data, (err)->
          console.log "error caching message: #{err}" if err

        res.publish null, data
        res.send null, "ack"

    cb()