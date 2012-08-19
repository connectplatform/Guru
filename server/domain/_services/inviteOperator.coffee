stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res, chatId, sessionId) ->
  metaInfo =
    isWatching: 'false'
    type: 'invite'
    requestor: res.cookie 'session'

  Session.allSessions.members (err, sessionIds) ->
    ChatSession.add sessionId, chatId, metaInfo, (err) ->
      res.reply err
