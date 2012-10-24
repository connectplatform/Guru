async = require 'async'
stoic = require 'stoic'
pulsar = config.require 'load/pulsar'
{Session, ChatSession, Chat} = stoic.models

module.exports = (res, chatId) ->
  Session.accountLookup.get res.cookie('session'), (err, accountId) ->
    ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
      getRole = (chatSession, cb) ->
        chatSession.session.role.get (err, role) ->
          chatSession.role = role
          cb err, chatSession

      async.map chatSessions, getRole, (err, chatSessions) ->
        [visitorChatSession] = chatSessions.filter (s) -> s.role is 'Visitor'

        Chat(accountId).get(chatId).status.set 'vacant', (err) ->
          config.log.error 'Error setting chat status in kickUser', {error: err, chatId: chatId} if err
          visitorChatSession.session.delete (err) ->
            config.log.error 'Error deleting session in kickUser', {error: err, chatId: chatId} if err
            ChatSession(accountId).remove visitorChatSession.sessionId, chatId, (err) ->
              if err
                meta = {error: err, sessionId: visitorChatSession.sessionId, chatId: chatId}
                config.log.error 'Error removing chat session in kickUser', meta

              #Trigger callbacks on visitor's page
              notify = pulsar.channel chatId
              notify.emit 'chatEnded'

              res.reply null, null
