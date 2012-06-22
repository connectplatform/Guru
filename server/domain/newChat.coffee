createChannel = require './createChannel'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->
      res.cookie 'username', data.username or 'anonymous'

      unless veinServer.services[res.cookie 'channel']?
        getId = ->
          "testChat"
          #rand = -> (((1 + Math.random()) * 0x10000000) | 0).toString 16
          #"service#{rand()+rand()+rand()}"

        channelName = getId()

        createChannel channelName, veinServer

        res.cookie 'channel', channelName
        res.send null, channel: channelName

      else
        res.send null, channel: res.cookie 'channel'

