stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    Session(accountId).get(sessionId).unreadMessages.getall (err, chats={}) ->
      message = chats
      event = 'unreadMessages'
      done err, event, message
