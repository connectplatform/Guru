createChannel = require './createChannel'
redisFactory = require '../redis'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->
      res.cookie 'username', data.username or 'anonymous'

      existingChannel = unescape res.cookie 'channel'

      unless veinServer.services[existingChannel]?
        redisFactory (redis)->
          redis.chats.create (channelName)->
            createChannel channelName, veinServer, ->
              res.cookie 'channel', channelName
              res.send null, channel: channelName
      else
        res.send null, channel: existingChannel