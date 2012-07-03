createChannel = require './createChannel'
redis = require '../redis'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->

      username = data.username or 'anonymous'

      redis.chats.create (channelName)->

        #TODO: move this up to middleware
        redis.sessions.create 'visitor', channelName, (sessionId)->
          redis.sessions.setChatName sessionId, username, (err)->
            console.log "error setting session chatname in newChat: #{err}" if err
            res.cookie 'session', sessionId

            visitorMeta =
              username: username
              website: null 
              department: null

            redis.chats.setVisitorMeta channelName, visitorMeta, (err, data)->
              console.log "error setting visitorMeta in newChat: #{err}" if err

              redis.chats.visitorArrived channelName, (err, data)->
                console.log "error setting visitorArrived in newChat: #{err}" if err
                
                createChannel channelName, veinServer, ->
                  res.cookie 'channel', channelName
                  res.send null, channel: channelName