db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
    data =
      accountId: accountId
      sessionId: targetSessionId
      chatId: chatId
      relation: 'Invite'
      initiator: sessionId
    
    # You cannot invite yourself to a chat
    # TODO: Implement as filter, via jargon
    err = Error 'You cannot invite yourself to a Chat'
    done err, null if sessionId == targetSessionId

    # You cannot invite a Visitor to join a chat
    # TODO: Implement as filter, via jargon
    Session.findById targetSessionId, (err, session) ->
      done err, null if err
      
      noSessionErr = Error 'No Session exists with targetSessionId'
      done noSessionErr, null unless session?
      
      err = Error 'You cannot invite a Visitor to join a Chat'
      done err, null unless session?.userId

      ChatSession.create data, done