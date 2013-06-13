async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

# In this service
module.exports =
  required: ['chatId', 'accountId', 'sessionSecret']
  service: ({chatId}, done) ->

    # First find all ChatSessions linking some Session to the Chat identified by chatId.
    ChatSession.find {chatId}, (err, chatSessions) ->
      return done err if err
      # Collect the sessionId's associated with our Chat.
      sessionIds = (cs.sessionId for cs in chatSessions)
      
      # Find the Session with no userId, which implies that the Session is not
      # associated to an Operator or Owner, and thus represents a Visitor.
      Session.findOne {userId: null, _id: '$in': sessionIds}, (err, visitorSession) ->
        return done err, null if err

        err = new Error 'Chat has no Visitor as a member'
        return done err unless visitorSession?

        # Find the ChatSession that links our Visitor to the Chat.
        ChatSession.findOne {sessionId: visitorSession?._id}, (err, vcs) ->
          return done err if err
          
          # Remove the ChatSession,
          vcs?.remove (err) ->
            Chat.findById chatId, (err, chat) ->
              return done err if err
              return done (new Error 'Chat not found') unless chat?
              
              # ASSUMPTION: Only one Visitor per Chat.
              # Since we have removed this Visitor, the Chat can only be linked
              # to Operators, so Chat status is 'Vacant'
              chat.status = 'Vacant'
              chat.save done

              # # Note
              # The client, using Particle, will detect this change via either
              # the removal of the linking ChatSession, or the change in value
              # of Chat.status.
