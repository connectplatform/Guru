redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (res, chatID) ->
  sessionID = unescape res.cookie('session')
  console.log "setting session: #{sessionID}, chat: #{chatID} to 0 messages"
  Session.get(sessionID).unreadChats.hrem chatID, ->
  res.send null, null
