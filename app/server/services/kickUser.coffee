async = require 'async'
stoic = require 'stoic'
pulsar = config.require 'load/pulsar'
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
        config.log.error 'Error setting chat status in kickUser', {error: err, chatId: chatId} if err
        visitorChatSession.session.delete (err) ->
          config.log.error 'Error deleting session in kickUser', {error: err, chatId: chatId} if err
          ChatSession.remove visitorChatSession.sessionId, chatId, (err) ->
            config.log.error 'Error removing chat session in kickUser', {error: err, sessionId: visitorChatSession.sessionId, chatId: chatId} if err

            #Trigger callbacks on visitor's page
            notify = pulsar.channel chatId
            notify.emit 'chatEnded'

            res.reply null, null
