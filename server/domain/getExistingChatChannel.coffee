redis = require '../redis'

module.exports = (veinServer)->
  unless veinServer.services["getExistingChatChannel"]?
    veinServer.add 'getExistingChatChannel', (res) ->

      userChannel = unescape res.cookie 'channel'
      # if client cookie exists and also exists server side
      if userChannel? and veinServer.services[userChannel]?
        redis.chats.exists userChannel, (err, data)->
          console.log "error checking if chat exists: #{err}" if err?
          return res.send null, channel: userChannel if data is 1 or data is '1'
          return res.send null, null

      else
        res.send null, null
