async = require 'async'
redgoose = require 'redgoose'
{SessionChat, Session, Chat} = redgoose.models

module.exports = (res, chatId) ->

  #TODO: sessionchat isn't adding for user correctly... problem probably elsewhere
  SessionChat.getSessionsByChat chatId, (err, sessions) ->
    getRole = (relation, cb) ->
      Session.get(relation.sessionId).role.get (err, role) ->
        relation.role = role
        cb err, relation
    async.map sessions, getRole, (err, sessions) ->
      [visitorSession] = sessions.filter (s) -> s.role is 'Visitor'
      {sessionId} = visitorSession

      session = Session.get(sessionId)
      session.visitorChat.get (err, chatId) ->
        console.log "Error finding chat in kick user: #{err}" if err?
        Chat.get(chatId).status.set 'vacant', (err) ->
          console.log "Error finding chat in kick user: #{err}" if err?
          session.delete (err) ->
            console.log "Error deleting session: #{err}" if err?
            res.send null, null