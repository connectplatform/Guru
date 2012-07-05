createChannel = require './createChannel'
redis = require '../redis'
redgoose = require 'redgoose'

module.exports = (veinServer) ->
  unless veinServer.services["newChat"]?
    veinServer.add 'newChat', (res, data) ->

      username = data.username or 'anonymous'

      redis.chats.create (channelName)->

        sessionId = unescape(res.cookie('session'))
        {Session} = redgoose.models

        #TODO: move this up to middleware
        Session.create {role: 'visitor', chatName: username}, (err, session)->
          console.log "error creating session: #{err}" if err
          sessionId = session.id
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