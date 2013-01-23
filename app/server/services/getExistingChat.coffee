stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports =
  optional: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    return done null, {reason: 'no session ID'} unless sessionId
    return done null, {reason: 'no account ID'} unless accountId

    ChatSession(accountId).getBySession sessionId, (err, [chatSession]) ->
      found = if chatSession then chatSession.chatId else null
      return done err, {chatId: found}
