db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
    
    data =
      accountId: accountId
      sessionId: targetSessionId
      chatId: chatId
      relation: 'Invite'
      initiator: sessionId
      
    ChatSession.create data, done