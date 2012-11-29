stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    Session(accountId).get(sessionId).unansweredChats.count (err, chatCount) ->
      message = {count: chatCount}
      event = 'unansweredChats'
      done err, event, message
