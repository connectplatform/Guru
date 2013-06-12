db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionSecret, accountId, chatId, targetSessionId}, done) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err if err or not session?

      sessionId = session._id
      # You cannot invite yourself to a chat
      # TODO: Implement as filter, via jargon
      err = Error 'You cannot invite yourself to a Chat'
      return done err, null if sessionId == targetSessionId
      
      # You cannot invite a Visitor to join a chat
      # TODO: Implement as filter, via jargon
      Session.findById targetSessionId, (err, session) ->
        return done err, null if err
      
        noSessionErr = Error 'No Session exists with targetSessionId'
        return done noSessionErr, null unless session?
      
        err = Error 'You cannot invite a Visitor to join a Chat'
        return done err, null unless session?.userId
        
        data =
          accountId: accountId
          sessionId: targetSessionId
          chatId: chatId
          relation: 'Invite'
          initiator: sessionId
        ChatSession.create data, done