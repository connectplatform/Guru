createChannel = require './createChannel'
redisFactory = require '../redis'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->
      res.cookie 'username', data.username or 'anonymous'

      redisFactory (redis)->
        redis.chats.create (channelName)->


          visitorMeta =
            username: res.cookie('username') 
            website: null
            department: null

          redis.chats.setVisitorMeta channelName, visitorMeta, (err, data)->
            console.log "error setting visitorMeta in newChat: #{err}" if err

            redis.chats.visitorArrived channelName, (err, data)->
              console.log "error setting visitorArrived in newChat: #{err}" if err
              
              createChannel channelName, veinServer, ->
                res.cookie 'channel', channelName
                res.send null, channel: channelName