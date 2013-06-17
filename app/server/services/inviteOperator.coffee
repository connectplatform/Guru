db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
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