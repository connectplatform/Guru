db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
    data =
      accountId: accountId
      sessionId: targetSessionId
      chatId: chatId
      relation: 'Transfer'
      initiator: sessionId

    # You cannot send yourself a Transfer request
    # TODO: Implement as filter, via jargon
    err = new Error 'You cannot send yourself a Transfer request'
    return done err if (sessionId is targetSessionId)

    # You cannot send a transfer request to a Visitor
    # TODO: Implement as filter, via jargon
    Session.findById targetSessionId, (err, session) ->
      return done err if err
      
      noSessionErr = new Error 'No Session exists with targetSessionId'
      return done noSessionErr unless session?
      
      err = new Error 'You cannot send a transfer request to a Visitor'
      return done err unless session?.userId

      ChatSession.create data, done
