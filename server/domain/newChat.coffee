createChannel = require './createChannel'

module.exports = (veinServer)->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data)->
      username = if data.username? then data.username else 'anonymous'
      unless res.cookie('login') is 'true' and res.cookie('username')? and veinServer.services[res.cookie('channel')]?
        getId = ->
          rand = -> (((1 + Math.random()) * 0x10000000) | 0).toString 16
          "service#{rand()+rand()+rand()}"
        channelName = getId()
        channelName = getId() while veinServer.services[channelName]?

        createChannel channelName, veinServer

        res.cookie 'login', 'true'
        res.cookie 'username', username
        res.cookie 'channel', channelName

      data =
        username: res.cookie 'username'
        channel: res.cookie 'channel'

      err = undefined #TODO use this for actual check
      res.send err, data
