module.exports = (res, sessionId) ->
  #TODO: change this to take channelId and look up session
  redgoose = require 'redgoose'
  {Session, Chat} = redgoose.models

  session = Session.get(sessionId)

  session.visitorChat.get (err, chatId) ->
    console.log "chatId: #{chatId}"
    console.log "Error finding chat in kick user: #{err}" if err?
    Chat.get(chatId).status.set 'vacant', (err) ->
      console.log "Error finding chat in kick user: #{err}" if err?
      session.delete (err) ->
        console.log "Error deleting session: #{err}" if err?
        res.send null, null