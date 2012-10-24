stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).unansweredChats.count (err, chatCount) ->
      message = {count: chatCount}
      event = 'unansweredChats'
      done err, event, message
