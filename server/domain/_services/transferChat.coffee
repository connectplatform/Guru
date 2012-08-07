redgoose = require 'redgoose'
{Session, ChatSession} = redgoose.models

module.exports = (res, chatId, sessionId) ->
  metaInfo =
    isWatching: 'false'
    type: 'transfer'
    requestor: res.cookie 'session'

  Session.allSessions.members (err, sessionIds) ->
    ChatSession.add sessionId, chatId, metaInfo, (err) ->
      res.send err
