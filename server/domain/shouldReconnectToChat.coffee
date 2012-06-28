redisFactory = require '../redis'

module.exports = (veinServer)->
  unless veinServer.services["shouldReconnectToChat"]?
    veinServer.add 'shouldReconnectToChat', (res) ->

      existingChannel = unescape res.cookie 'channel'
      if existingChannel? and veinServer.services[existingChannel]?
        redisFactory (redis)->
          redis.chats.exists existingChannel, (err, data)->
            if data is 1
              res.send null, channel: existingChannel
              return
              
      res.send null, null