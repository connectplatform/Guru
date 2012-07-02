redisFactory = require '../redis'

module.exports = (veinServer)->
  console.log veinServer.services
  unless veinServer.services["getExistingChatChannel"]?
    console.log "adding getExistingChatChannel"
    veinServer.add 'getExistingChatChannel', (res) ->

      existingChannel = unescape res.cookie 'channel'
      if existingChannel? and veinServer.services[existingChannel]?
        redisFactory (redis)->
          redis.chats.exists existingChannel, (err, data)->
            if data is 1
              res.send null, channel: existingChannel
              return
              
      res.send null, null