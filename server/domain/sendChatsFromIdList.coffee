async = require 'async'
redgoose = require 'redgoose'

module.exports = (res, err, list) ->
  res.send err, null if err
  data = list.filter (element) ->
    element != 'true' #this is a bogus item added by the redis query TODO: should I worry about this?
    
  {Chat} = redgoose.models
  chats = []

  pushChat = (item, cb) ->
    Chat.get(item).dump (err, data)->
      console.log "Error getting chat from cache: data:#{data}, error:#{err}" if err
      message.timestamp = new Date(parseInt(message.timestamp)) for message in data.history
      chats.push data
      cb()

  async.forEach data, pushChat, ->
    res.send null, chats