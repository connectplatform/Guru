async = require 'async'
redgoose = require 'redgoose'

module.exports = (res, err, list) ->
  res.send err, null if err
  chatIDs = list.filter (element) ->
    element != 'true' #this is a bogus chatID added by the redis query TODO: should I worry about this?

  {Chat} = redgoose.models
  chats = []

  pushChat = (chatID, next) ->
    Chat.get(chatID).dump (err, chat)->
      console.log "Error getting chat from cache: chat:#{chat}, error:#{err}" if err
      message.timestamp = new Date(parseInt(message.timestamp)) for message in chat.history
      chats.push chat
      next()

  async.forEach chatIDs, pushChat, ->
    res.send null, chats
