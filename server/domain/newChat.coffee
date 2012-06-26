createChannel = require './createChannel'
redisFactory = require '../redis'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->
      res.cookie 'username', data.username or 'anonymous'

      unless veinServer.services[res.cookie 'channel']?
        getId = ->
          "testChat"

        redisFactory (redis)->
          redis.chats.create (channelName)->

            createChannel channelName, veinServer

            res.cookie 'channel', channelName
            res.send null, channel: channelName

      else
        res.send null, channel: res.cookie 'channel'