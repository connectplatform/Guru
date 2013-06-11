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
    err = Error 'You cannot send yourself a Transfer request'
    done err, null if sessionId == targetSessionId

    # You cannot send a transfer request to a Visitor
    # TODO: Implement as filter, via jargon
    Session.findById targetSessionId, (err, session) ->
      done err, null if err
      
      noSessionErr = Error 'No Session exists with targetSessionId'
      done noSessionErr, null unless session?
      
      err = Error 'You cannot send a transfer request to a Visitor'
      done err, null unless session?.userId

      ChatSession.create data, done
