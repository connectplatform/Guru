async = require 'async'
stoic = require 'stoic'
pulsar = require '../../pulsar'
{ChatSession, Chat} = stoic.models

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

            res.reply null, null
