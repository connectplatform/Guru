redis = require '../redis'

module.exports = (veinServer)->
  unless veinServer.services["getExistingChatChannel"]?
    veinServer.add 'getExistingChatChannel', (res) ->

      existingChannel = unescape res.cookie 'channel'
      if existingChannel? and veinServer.services[existingChannel]?
        redis.chats.exists existingChannel, (err, data)->
          console.log "error checking if chat exists: #{err}" if err?
          if data is 1 or data is '1'
            res.send null, channel: existingChannel
      else        
        res.send null, null