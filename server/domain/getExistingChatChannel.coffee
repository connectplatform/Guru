redgoose = require 'redgoose'

module.exports = (veinServer, pulsar)->
  unless veinServer.services["getExistingChatChannel"]?
    veinServer.add 'getExistingChatChannel', (res) ->

      userChannel = unescape res.cookie 'channel'
      # if client cookie exists and also exists server side
      if userChannel? and pulsar.channels[userChannel]?
        {Chat} = redgoose.models
        Chat.allChats.belongs userChannel, (err, data) ->
          console.log "error checking if chat exists: #{err}" if err?
          return res.send null, channel: userChannel if data is 1 or data is '1'
          return res.send null, null

      else
        res.send null, null