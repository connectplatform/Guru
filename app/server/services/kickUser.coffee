async = require 'async'
# stoic = require 'stoic'
# {ChatSession, Chat} = stoic.models

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->

    # get sessions by chat
    ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
      getRole = (chatSession, cb) ->
        chatSession.session.role.get (err, role) ->
          chatSession.role = role
          cb err, chatSession

      # find the visitor
      async.map chatSessions, getRole, (err, chatSessions) ->
        [visitorChatSession] = chatSessions.filter (s) -> s.role is 'Visitor'

        unless visitorChatSession
          return done()

        # remove the visitor from the chat
        visitorChatSession.session.delete (err) ->
          config.log.error 'Error deleting session in kickUser', {error: err, chatId: chatId} if err

          #Trigger callbacks on visitor's page
          notify = pulsar.channel chatId
          notify.emit 'chatEnded'

          done()
