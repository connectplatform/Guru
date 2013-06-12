db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  service: ({chatId, sessionId}, done) ->
    ChatSession.find {chatId}, (err, chatSessions) ->
      # Get all the salient sessionIds
      activeSessionIds = (cs.sessionId for cs in chatSessions)
      
      # If the Session with _id == sessionId is Active
      if sessionId in activeSessionIds
        ChatSession.remove {chatId, sessionId}, (err, chatSession) ->
          return done err if err

          # Consider all the chatSessions except for the one that
          # we just successfully "left" (removed)
          pred1 = (cs) -> cs.sessionId != sessionId
          remainingChatSessions = chatSessions.filter pred1

          # If there are no remaining ChatSessions linking some Session
          # to the Chat, then the Chat is vacant.
          chatIsEmpty = (remainingChatSessions.length == 0)
          if chatIsEmpty
            Chat.findById chatId, (err, chat) ->
              return done err if err
              return done (new Error 'Chat not found') if not chat?
              
              chat?.status = 'Vacant'
              chat?.save done

          # Now we want to know if there are any active Operators left in
          # the Chat. If there are, there will be a ChatSession in the
          # array `remainingChatSessions` which links the Operator to
          # the Chat, and the relation will be 'Member'. We find this array.
          isMember = (cs) -> cs.relation == 'Member'
          remainingMemberChatSessions = remainingChatSessions.filter isMember
          remainingMemberSessionIds = (cs.sessionId for cs in remainingMemberChatSessions)

          cond =
            _id: '$in': remainingMemberSessionIds
            userId: '$ne': null
          Session.find cond, (err, sessions) ->
            return done err if err

            allOperatorsGone = sessions.length == 0

            Chat.findById chatId, (err, chat) ->
              return done err if err
              return done (new Error 'Chat not found') if not chat?
              
              if allOperatorsGone
                chat?.status = 'Waiting'
              else
                chat?.status = 'Active'
              chat?.save done

