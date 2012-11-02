stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports =
  optional: ['sessionId']
  service: ({sessionId, accountId}, done) ->
    return done() unless sessionId

    Session.accountLookup.get sessionId, (err, accountId) ->

      ChatSession(accountId).getBySession sessionId, (err, [chatSession]) ->
        found = if chatSession then {chatId: chatSession.chatId} else null
        return done err, found
