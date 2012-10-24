stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).unreadMessages.getall (err, chats={}) ->
      message = chats
      event = 'unreadMessages'
      done err, event, message
