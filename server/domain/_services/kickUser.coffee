async = require 'async'
redgoose = require 'redgoose'
{ChatSession, Chat} = redgoose.models

module.exports = (res, chatId) ->
  ChatSession.getByChat chatId, (err, chatSessions) ->
    getRole = (chatSession, cb) ->
      chatSession.session.role.get (err, role) ->
        chatSession.role = role
        cb err, chatSession
    async.map chatSessions, getRole, (err, chatSessions) ->
      [visitorChatSession] = chatSessions.filter (s) -> s.role is 'Visitor'

      chatId = visitorChatSession.chatId
      Chat.get(chatId).status.set 'vacant', (err) ->
        console.log "Error finding chat in kick user: #{err}" if err?
        visitorChatSession.session.delete (err) ->
          console.log "Error deleting session: #{err}" if err?
          res.send null, null