stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =

  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    return done() unless sessionId

    ChatSession(accountId).getBySession sessionId, (err, [chatSession]) ->
      found = if chatSession then {chatId: chatSession.chatId} else null
      return done err, found
