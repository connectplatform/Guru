async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models


module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->

    # First find all ChatSessions linking some Session to the Chat identified by chatId.
    ChatSession.find {chatId}, (err, chatSessions) ->
      # Collect the sessionId's associated with our Chat.
      sessionIds = (cs.sessionId for cs in chatSessions)
      
      # Find the Session with no userId, which implies that the Session is not
      # associated to an Operator or Owner, and thus represents a Visitor.
      Session.findOne {userId: null, _id: '$in': sessionIds}, (err, visitorSession) ->
        done err, null if err

        # Find the ChatSession that links our Visitor to the Chat.
        ChatSession.findOne {sessionId: visitorSession._id}, (err, vcs) ->
          # Remove the ChatSession,
          vcs.remove (err) ->
            Chat.findById chatId, (err, chat) ->
              done err, null if err
              # ASSUMPTION: Only one Visitor per Chat.
              # Since we have removed this Visitor, the Chat can only be linked
              # to Operators, so Chat status is 'Vacant'
              chat.status = 'Vacant'
              chat.save done

              # # Note
              # The client, using Particle, will detect this change via either
              # the removal of the linking ChatSession, or the change in value
              # of Chat.status.

    # # get sessions by chat
    # ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
    #   getRole = (chatSession, cb) ->
    #     chatSession.session.role.get (err, role) ->
    #       chatSession.role = role
    #       cb err, chatSession

    #   # find the visitor
    #   async.map chatSessions, getRole, (err, chatSessions) ->
    #     [visitorChatSession] = chatSessions.filter (s) -> s.role is 'Visitor'

    #     unless visitorChatSession
    #       return done()

    #     # remove the visitor from the chat
    #     visitorChatSession.session.delete (err) ->
    #       config.log.error 'Error deleting session in kickUser', {error: err, chatId: chatId} if err

    #       #Trigger callbacks on visitor's page
    #       notify = pulsar.channel chatId
    #       notify.emit 'chatEnded'

    #       done()
