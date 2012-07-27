async = require 'async'
redgoose = require 'redgoose'
pulsar = require '../../pulsar'
{ChatSession, Chat} = redgoose.models

module.exports = (res, chatId) ->
  ChatSession.getByChat chatId, (err, chatSessions) ->
    getRole = (chatSession, cb) ->
      chatSession.session.role.get (err, role) ->
        chatSession.role = role
        cb err, chatSession
    async.map chatSessions, getRole, (err, chatSessions) ->
      [visitorChatSession] = chatSessions.filter (s) -> s.role is 'Visitor'

      Chat.get(chatId).status.set 'vacant', (err) ->
        console.log "Error setting chat status: #{err}" if err?
        visitorChatSession.session.delete (err) ->
          console.log "Error deleting session: #{err}" if err?
          ChatSession.remove visitorChatSession.sessionId, chatId, (err) ->
            console.log "Error removing chat session: #{err}" if err?

            #Trigger callbacks on visitor's page
            notify = pulsar.channel chatId
            notify.emit 'chatEnded'

            res.send null, null
