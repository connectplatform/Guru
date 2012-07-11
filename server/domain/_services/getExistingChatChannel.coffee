pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{Chat} = redgoose.models

module.exports = (res) ->

  userChannel = unescape res.cookie 'channel'

  # if client cookie exists and also exists server side
  if userChannel?
    Chat.allChats.ismember userChannel, (err, data) ->
      console.log "error checking if chat exists: #{err}" if err?

      if data is 1 or data is '1'
        channel = pulsar.channel userChannel
        return res.send null, channel: userChannel

      else
        return res.send null, null

  else
    res.send null, null
